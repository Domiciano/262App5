import 'package:moviles_auth/features/chat/domain/entities/message.dart';

/// The only file that talks to the messages table, by Realtime and by plain queries.
class SupabaseMessageDataSource {
  static const table = 'messages';

  Stream<List<Message>> watchLatest({required int limit}) {
    throw UnimplementedError();
  }

  Future<List<Message>> fetchBefore(
    DateTime before, {
    required int limit,
  }) async {
    throw UnimplementedError();
  }

  Future<void> send(String content, {String? imagePath}) async {
    throw UnimplementedError();
  }
}
