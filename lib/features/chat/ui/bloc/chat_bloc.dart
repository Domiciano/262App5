import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviles_auth/features/chat/ui/bloc/chat_event.dart';
import 'package:moviles_auth/features/chat/ui/bloc/chat_state.dart';
import 'package:moviles_auth/features/conversations/domain/entities/conversation.dart';

// LAB parte 1 (chat sencillo en tiempo real)
// LAB parte 2 (paginación: al llegar arriba, pedir los 5 mensajes anteriores)
// LAB parte 3 (agregar imagen, esta por medio de un bucket privado)

/// Listens to the latest messages of one conversation, pages back and sends new ones.
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  static const liveSize = 15;
  static const pageSize = 5;

  final Conversation conversation;

  ChatBloc(this.conversation) : super(const ChatState()) {
    on<ChatStarted>(_onStarted);
    on<MessagesUpdated>(_onMessagesUpdated);
    on<ChatStreamFailed>(_onStreamFailed);
    on<MessageSent>(_onMessageSent);
    on<OlderMessagesRequested>(_onOlderRequested);
    on<ChatPhotoRequested>(_onPhotoRequested);
    on<ChatPhotoRemoved>(_onPhotoRemoved);
  }

  // LAB parte 1
  Future<void> _onStarted(ChatStarted event, Emitter<ChatState> emit) async {
    debugPrint('ChatBloc recibió $event');
  }

  // LAB parte 1, y en la parte 2 se junta con los anteriores
  void _onMessagesUpdated(MessagesUpdated event, Emitter<ChatState> emit) {
    debugPrint('ChatBloc recibió $event');
  }

  // LAB parte 1
  void _onStreamFailed(ChatStreamFailed event, Emitter<ChatState> emit) {
    debugPrint('ChatBloc recibió $event');
  }

  // LAB parte 1, y en la parte 3 se le agrega la foto
  Future<void> _onMessageSent(
    MessageSent event,
    Emitter<ChatState> emit,
  ) async {
    debugPrint('ChatBloc recibió $event');
  }

  // LAB parte 2
  Future<void> _onOlderRequested(
    OlderMessagesRequested event,
    Emitter<ChatState> emit,
  ) async {
    debugPrint('ChatBloc recibió $event');
  }

  // LAB parte 3
  Future<void> _onPhotoRequested(
    ChatPhotoRequested event,
    Emitter<ChatState> emit,
  ) async {
    debugPrint('ChatBloc recibió $event');
  }

  // LAB parte 3
  void _onPhotoRemoved(ChatPhotoRemoved event, Emitter<ChatState> emit) {
    debugPrint('ChatBloc recibió $event');
  }
}
