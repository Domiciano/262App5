import 'package:moviles_auth/features/chat/domain/entities/message.dart';
import 'package:moviles_auth/features/chat/domain/repository/message_repository.dart';
import 'package:moviles_auth/injection_container.dart';

/// Returns the stream of the latest messages, newest first, each one with its photo URL.
class WatchMessagesUseCase {
  final MessageRepository _messages = sl();

  Stream<List<Message>> call({required int limit}) {
    return _messages.watchLatest(limit: limit).asyncMap(_withImages);
  }

  Future<List<Message>> _withImages(List<Message> messages) {
    return Future.wait(messages.map(_withImage));
  }

  Future<Message> _withImage(Message message) async {
    final path = message.imagePath;
    if (path == null) return message;
    return message.copyWith(imageUrl: await _messages.imageUrl(path));
  }
}
