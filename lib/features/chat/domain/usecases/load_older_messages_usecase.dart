import 'package:moviles_auth/features/chat/domain/entities/message.dart';

/// Brings, only once, the messages sent before a given moment, newest first.
class LoadOlderMessagesUseCase {
  Future<List<Message>> call(DateTime before, {required int limit}) async {
    throw UnimplementedError();
  }
}
