import 'package:moviles_auth/features/avatar/domain/entities/picked_photo.dart';
import 'package:moviles_auth/features/chat/domain/entities/message.dart';

enum ChatStatus { initial, loading, success, failure }

/// Single state of the chat: the messages, newest first, and what is happening right now.
class ChatState {
  final ChatStatus status;
  final List<Message> messages;
  final bool isLoadingOlder;
  final bool hasMore;
  final bool isSending;
  final PickedPhoto? photo;
  final String? errorMessage;

  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.isLoadingOlder = false,
    this.hasMore = true,
    this.isSending = false,
    this.photo,
    this.errorMessage,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<Message>? messages,
    bool? isLoadingOlder,
    bool? hasMore,
    bool? isSending,
    PickedPhoto? photo,
    bool removePhoto = false,
    String? errorMessage,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      isLoadingOlder: isLoadingOlder ?? this.isLoadingOlder,
      hasMore: hasMore ?? this.hasMore,
      isSending: isSending ?? this.isSending,
      photo: removePhoto ? null : photo ?? this.photo,
      errorMessage: errorMessage,
    );
  }

  @override
  String toString() {
    return 'ChatState(status: ${status.name}, '
        'messages: ${messages.length}, '
        'olderLoading: $isLoadingOlder, hasMore: $hasMore, '
        'sending: $isSending, photo: ${photo == null ? 'no' : 'sí'}, '
        'error: $errorMessage)';
  }
}
