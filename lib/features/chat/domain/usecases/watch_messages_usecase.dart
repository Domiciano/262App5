import 'package:moviles_auth/features/chat/domain/entities/message.dart';

/// Returns the stream of the latest messages, newest first, each one with its photo URL.
class WatchMessagesUseCase {
  Stream<List<Message>> call(String conversationId, {required int limit}) {
    throw UnimplementedError();
  }
}
