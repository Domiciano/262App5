import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moviles_auth/features/auth/domain/entities/profile.dart';
import 'package:moviles_auth/features/avatar/domain/entities/picked_photo.dart';
import 'package:moviles_auth/features/chat/domain/entities/message.dart';
import 'package:moviles_auth/features/chat/ui/bloc/chat_bloc.dart';
import 'package:moviles_auth/features/chat/ui/bloc/chat_event.dart';
import 'package:moviles_auth/features/chat/ui/bloc/chat_state.dart';
import 'package:moviles_auth/features/chat/ui/components/message_bubble.dart';
import 'package:moviles_auth/features/chat/ui/screens/chat_screen.dart';
import 'package:moviles_auth/features/conversations/domain/entities/conversation.dart';

class _FakeChatBloc extends Bloc<ChatEvent, ChatState> implements ChatBloc {
  final events = <ChatEvent>[];

  @override
  final conversation = const Conversation(
    id: 'c1',
    contact: Profile(id: 'u2', username: 'ana', fullName: 'Ana Ruiz'),
  );

  _FakeChatBloc(List<Message> messages)
    : super(ChatState(status: ChatStatus.success, messages: messages)) {
    on<ChatEvent>((event, emit) {
      events.add(event);
      if (event is MessagesUpdated) {
        emit(state.copyWith(messages: event.messages));
      }
      if (event is ChatPhotoRequested) {
        emit(state.copyWith(photo: _photo));
      }
      if (event is ChatPhotoRemoved) {
        emit(state.copyWith(removePhoto: true));
      }
    });
  }
}

final _photo = PickedPhoto(
  bytes: Uint8List.fromList(const [
    0x89,
    0x50,
    0x4E,
    0x47,
    0x0D,
    0x0A,
    0x1A,
    0x0A,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x48,
    0x44,
    0x52,
    0x00,
    0x00,
    0x00,
    0x01,
    0x00,
    0x00,
    0x00,
    0x01,
    0x08,
    0x06,
    0x00,
    0x00,
    0x00,
    0x1F,
    0x15,
    0xC4,
    0x89,
    0x00,
    0x00,
    0x00,
    0x0D,
    0x49,
    0x44,
    0x41,
    0x54,
    0x78,
    0x9C,
    0x63,
    0xF8,
    0xCF,
    0xC0,
    0xF0,
    0x1F,
    0x00,
    0x05,
    0x00,
    0x01,
    0xFF,
    0x89,
    0x99,
    0x3D,
    0x1D,
    0x00,
    0x00,
    0x00,
    0x00,
    0x49,
    0x45,
    0x4E,
    0x44,
    0xAE,
    0x42,
    0x60,
    0x82,
  ]),
  extension: 'png',
);

Message _message(int n, {bool mine = false}) => Message(
  id: 'm$n',
  content: 'Mensaje $n',
  createdAt: DateTime.utc(2026, 11, 6, 10).add(Duration(minutes: n)),
  isMine: mine,
);

List<Message> _many(int count) => [
  for (var n = count; n >= 1; n--) _message(n, mine: n.isEven),
];

Future<_FakeChatBloc> _pump(WidgetTester tester, List<Message> messages) async {
  final bloc = _FakeChatBloc(messages);
  await tester.pumpWidget(
    MaterialApp(
      home: BlocProvider<ChatBloc>.value(
        value: bloc,
        child: const ChatScreen(),
      ),
    ),
  );
  await tester.pump();
  return bloc;
}

void main() {
  testWidgets('opening the chat starts listening', (tester) async {
    final bloc = await _pump(tester, const []);
    expect(bloc.events.first, isA<ChatStarted>());
    expect(
      find.text('Aún no hay mensajes. Escribe el primero.'),
      findsOneWidget,
    );
  });

  testWidgets('the app bar shows who I am chatting with', (tester) async {
    await _pump(tester, const []);
    expect(find.text('Ana Ruiz'), findsOneWidget);
  });

  testWidgets('my messages go right and the others go left', (tester) async {
    await _pump(tester, [_message(2, mine: true), _message(1)]);
    Align alignOf(String text) => tester.widget<Align>(
      find.ancestor(of: find.text(text), matching: find.byType(Align)).first,
    );
    expect(alignOf('Mensaje 2').alignment, Alignment.centerRight);
    expect(alignOf('Mensaje 1').alignment, Alignment.centerLeft);
  });

  testWidgets('the newest message is at the bottom', (tester) async {
    await _pump(tester, [_message(2), _message(1)]);
    final newest = tester.getTopLeft(find.text('Mensaje 2')).dy;
    final oldest = tester.getTopLeft(find.text('Mensaje 1')).dy;
    expect(newest, greaterThan(oldest));
  });

  testWidgets('sending fires MessageSent and clears the field', (tester) async {
    final bloc = await _pump(tester, const []);
    await tester.enterText(find.byType(TextField), 'Hola');
    await tester.tap(find.byTooltip('Enviar'));
    await tester.pump();
    final sent = bloc.events.whereType<MessageSent>().single;
    expect(sent.content, 'Hola');
    expect(find.text('Hola'), findsNothing);
  });

  testWidgets('an empty message is not sent', (tester) async {
    final bloc = await _pump(tester, const []);
    await tester.tap(find.byTooltip('Enviar'));
    await tester.pump();
    expect(bloc.events.whereType<MessageSent>(), isEmpty);
  });

  testWidgets('reaching the top asks for older messages once', (tester) async {
    final bloc = await _pump(tester, _many(40));
    await tester.drag(find.byType(ListView), const Offset(0, 20000));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, 300));
    await tester.pumpAndSettle();
    expect(bloc.events.whereType<OlderMessagesRequested>(), hasLength(1));
  });

  testWidgets('a new message scrolls back to the bottom', (tester) async {
    final bloc = await _pump(tester, _many(40));
    await tester.drag(find.byType(ListView), const Offset(0, 600));
    await tester.pumpAndSettle();
    final list = tester.widget<ListView>(find.byType(ListView));
    expect(list.controller!.offset, greaterThan(0));
    bloc.add(MessagesUpdated([_message(41, mine: true), ..._many(40)]));
    await tester.pumpAndSettle();
    expect(list.controller!.offset, 0);
  });

  testWidgets('the photo button attaches and removes a photo', (tester) async {
    final bloc = await _pump(tester, const []);
    await tester.tap(find.byTooltip('Adjuntar foto'));
    await tester.pump();
    expect(bloc.events.last, isA<ChatPhotoRequested>());
    expect(find.text('Quitar foto'), findsOneWidget);
    await tester.tap(find.text('Quitar foto'));
    await tester.pump();
    expect(bloc.events.last, isA<ChatPhotoRemoved>());
    expect(find.text('Quitar foto'), findsNothing);
  });

  testWidgets('a message with a photo path shows its picture box', (
    tester,
  ) async {
    await _pump(tester, [
      Message(
        id: 'p1',
        content: '',
        createdAt: DateTime.utc(2026, 11, 6, 10),
        isMine: false,
        imagePath: 'u1/foto.png',
      ),
    ]);
    expect(find.byType(MessageBubble), findsOneWidget);
    expect(find.byIcon(Icons.image_outlined), findsWidgets);
  });
}
