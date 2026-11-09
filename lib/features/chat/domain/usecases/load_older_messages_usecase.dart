import 'package:moviles_auth/features/chat/domain/entities/message.dart';
import 'package:moviles_auth/features/chat/domain/repository/message_repository.dart';
import 'package:moviles_auth/injection_container.dart';

/// Brings, only once, the messages sent before a given moment, newest first.
class LoadOlderMessagesUseCase {
  final MessageRepository _messages = sl();

  Future<List<Message>> call(
    String conversationId,
    DateTime before, {
    required int limit,
  }) async {
    final older = await _messages.fetchBefore(
      conversationId,
      before,
      limit: limit,
    );
    return Future.wait(older.map(_withImage));
  }

  Future<Message> _withImage(Message message) async {
    final path = message.imagePath;
    if (path == null) return message;
    return message.copyWith(imageUrl: await _messages.imageUrl(path));
  }
}
