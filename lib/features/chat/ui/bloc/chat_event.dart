import 'package:moviles_auth/features/chat/domain/entities/message.dart';

/// Something the chat screen, or the stream of messages, asks the ChatBloc to do.
abstract class ChatEvent {}

/// The chat screen opened: start listening to the latest messages.
class ChatStarted extends ChatEvent {
  @override
  String toString() {
    return 'ChatStarted()';
  }
}

/// The stream of messages brought a new list.
class MessagesUpdated extends ChatEvent {
  final List<Message> messages;

  MessagesUpdated(this.messages);

  @override
  String toString() {
    return 'MessagesUpdated(${messages.length} mensajes)';
  }
}

/// The stream of messages failed.
class ChatStreamFailed extends ChatEvent {
  final String message;

  ChatStreamFailed(this.message);

  @override
  String toString() {
    return 'ChatStreamFailed($message)';
  }
}

/// The user pressed Enviar.
class MessageSent extends ChatEvent {
  final String content;

  MessageSent(this.content);

  @override
  String toString() {
    return 'MessageSent($content)';
  }
}

/// The user scrolled up to the oldest message on screen.
class OlderMessagesRequested extends ChatEvent {
  @override
  String toString() {
    return 'OlderMessagesRequested()';
  }
}

/// The user wants to attach a photo from the gallery.
class ChatPhotoRequested extends ChatEvent {
  @override
  String toString() {
    return 'ChatPhotoRequested()';
  }
}

/// The user removed the attached photo before sending.
class ChatPhotoRemoved extends ChatEvent {
  @override
  String toString() {
    return 'ChatPhotoRemoved()';
  }
}
