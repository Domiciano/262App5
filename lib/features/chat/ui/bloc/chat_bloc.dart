import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles_auth/features/chat/domain/entities/message.dart';
import 'package:moviles_auth/features/chat/domain/usecases/load_older_messages_usecase.dart';
import 'package:moviles_auth/features/chat/domain/usecases/pick_chat_image_usecase.dart';
import 'package:moviles_auth/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:moviles_auth/features/chat/domain/usecases/watch_messages_usecase.dart';
import 'package:moviles_auth/features/chat/ui/bloc/chat_event.dart';
import 'package:moviles_auth/features/chat/ui/bloc/chat_state.dart';
import 'package:moviles_auth/injection_container.dart';

// LAB parte 1 (chat sencillo en tiempo real)
// LAB parte 2 (paginación: al llegar arriba, pedir los 5 mensajes anteriores)
// LAB parte 3 (agregar imagen, esta por medio de un bucket privado)

/// Listens to the latest messages, pages back through older ones and sends new ones.
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  static const liveSize = 15;
  static const pageSize = 5;

  final WatchMessagesUseCase _watchMessages = sl();
  final LoadOlderMessagesUseCase _loadOlder = sl();
  final SendMessageUseCase _sendMessage = sl();
  final PickChatImageUseCase _pickImage = sl();

  StreamSubscription<List<Message>>? _subscription;

  ChatBloc() : super(const ChatState()) {
    on<ChatStarted>(_onStarted);
    on<MessagesUpdated>(_onMessagesUpdated);
    on<ChatStreamFailed>(_onStreamFailed);
    on<MessageSent>(_onMessageSent);
    on<OlderMessagesRequested>(_onOlderRequested);
    on<ChatPhotoRequested>(_onPhotoRequested);
    on<ChatPhotoRemoved>(_onPhotoRemoved);
  }

  String _message(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  List<Message> _merge(List<Message> current, List<Message> incoming) {
    final byId = {
      for (final message in current) message.id: message,
      for (final message in incoming) message.id: message,
    };
    return byId.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  // LAB parte 1
  Future<void> _onStarted(ChatStarted event, Emitter<ChatState> emit) async {
    emit(state.copyWith(status: ChatStatus.loading));
    await _subscription?.cancel();
    _subscription = _watchMessages(limit: liveSize).listen(
      (messages) => add(MessagesUpdated(messages)),
      onError: (Object error) => add(ChatStreamFailed(_message(error))),
    );
  }

  // LAB parte 1, y en la parte 2 se junta con los anteriores
  void _onMessagesUpdated(MessagesUpdated event, Emitter<ChatState> emit) {
    emit(
      state.copyWith(
        status: ChatStatus.success,
        messages: _merge(state.messages, event.messages),
      ),
    );
  }

  // LAB parte 1
  void _onStreamFailed(ChatStreamFailed event, Emitter<ChatState> emit) {
    emit(
      state.copyWith(status: ChatStatus.failure, errorMessage: event.message),
    );
  }

  // LAB parte 1, y en la parte 3 se le agrega la foto
  Future<void> _onMessageSent(
    MessageSent event,
    Emitter<ChatState> emit,
  ) async {
    if (state.isSending) return;
    emit(state.copyWith(isSending: true));
    try {
      await _sendMessage(event.content, photo: state.photo);
      emit(state.copyWith(isSending: false, removePhoto: true));
    } on Exception catch (e) {
      emit(state.copyWith(isSending: false, errorMessage: _message(e)));
    }
  }

  // LAB parte 2
  Future<void> _onOlderRequested(
    OlderMessagesRequested event,
    Emitter<ChatState> emit,
  ) async {
    if (state.isLoadingOlder || !state.hasMore || state.messages.isEmpty) {
      return;
    }
    emit(state.copyWith(isLoadingOlder: true));
    try {
      final oldest = state.messages.last.createdAt;
      final older = await _loadOlder(oldest, limit: pageSize);
      emit(
        state.copyWith(
          isLoadingOlder: false,
          messages: _merge(state.messages, older),
          hasMore: older.length == pageSize,
        ),
      );
    } on Exception catch (e) {
      emit(state.copyWith(isLoadingOlder: false, errorMessage: _message(e)));
    }
  }

  // LAB parte 3
  Future<void> _onPhotoRequested(
    ChatPhotoRequested event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final photo = await _pickImage();
      if (photo != null) emit(state.copyWith(photo: photo));
    } on Exception catch (e) {
      emit(state.copyWith(errorMessage: _message(e)));
    }
  }

  // LAB parte 3
  void _onPhotoRemoved(ChatPhotoRemoved event, Emitter<ChatState> emit) {
    emit(state.copyWith(removePhoto: true));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
