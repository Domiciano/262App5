import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moviles_auth/features/auth/domain/entities/profile.dart';
import 'package:moviles_auth/features/conversations/domain/entities/contact.dart';
import 'package:moviles_auth/features/conversations/domain/entities/conversation.dart';
import 'package:moviles_auth/features/conversations/ui/bloc/contacts_bloc.dart';
import 'package:moviles_auth/features/conversations/ui/bloc/contacts_event.dart';
import 'package:moviles_auth/features/conversations/ui/bloc/contacts_state.dart';
import 'package:moviles_auth/features/conversations/ui/screens/contacts_screen.dart';

const _me = Profile(id: 'u1', username: 'yo', fullName: 'Yo Mismo');
const _ana = Profile(id: 'u2', username: 'ana', fullName: 'Ana Ruiz');

class _FakeContactsBloc extends Bloc<ContactsEvent, ContactsState>
    implements ContactsBloc {
  final events = <ContactsEvent>[];

  _FakeContactsBloc()
    : super(
        const ContactsState(
          status: ContactsStatus.success,
          contacts: [
            Contact(profile: _me, isMe: true),
            Contact(profile: _ana, isMe: false),
          ],
        ),
      ) {
    on<ContactsEvent>((event, emit) {
      events.add(event);
      if (event is ContactSelected) {
        emit(
          state.copyWith(
            opened: Conversation(id: 'c1', contact: event.contact),
          ),
        );
      }
    });
  }
}

Future<_FakeContactsBloc> _pump(WidgetTester tester) async {
  final bloc = _FakeContactsBloc();
  await tester.pumpWidget(
    MaterialApp(
      routes: {
        '/': (_) => BlocProvider<ContactsBloc>.value(
          value: bloc,
          child: const ContactsScreen(),
        ),
        '/chat': (context) {
          final conversation =
              ModalRoute.of(context)!.settings.arguments as Conversation;
          return Text(
            'chat ${conversation.id} con ${conversation.contact.username}',
          );
        },
      },
    ),
  );
  await tester.pump();
  return bloc;
}

void main() {
  testWidgets('lists every user, me included', (tester) async {
    final bloc = await _pump(tester);
    expect(bloc.events.first, isA<ContactsStarted>());
    expect(find.text('Yo Mismo (tú)'), findsOneWidget);
    expect(find.text('Ana Ruiz'), findsOneWidget);
  });

  testWidgets('tapping a user opens the chat with that conversation', (
    tester,
  ) async {
    final bloc = await _pump(tester);
    await tester.tap(find.text('Ana Ruiz'));
    await tester.pumpAndSettle();
    expect((bloc.events.last as ContactSelected).contact.id, 'u2');
    expect(find.text('chat c1 con ana'), findsOneWidget);
  });
}
