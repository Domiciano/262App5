import 'package:moviles_auth/features/chat/domain/entities/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// The only file that talks to the messages table, by Realtime and by plain queries.
class SupabaseMessageDataSource {
  static const table = 'messages';

  final SupabaseClient _client = Supabase.instance.client;

  String get _uid {
    return _client.auth.currentUser!.id;
  }

  Stream<List<Message>> watchLatest({required int limit}) {
    return _client
        .from(table)
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .limit(limit)
        .map((rows) => rows.map(_toMessage).toList());
  }

  Future<List<Message>> fetchBefore(
    DateTime before, {
    required int limit,
  }) async {
    try {
      final rows = await _client
          .from(table)
          .select()
          .lt('created_at', before.toUtc().toIso8601String())
          .order('created_at', ascending: false)
          .limit(limit);
      return rows.map(_toMessage).toList();
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> send(String content, {String? imagePath}) async {
    try {
      await _client.from(table).insert({
        'sender_id': _uid,
        'content': content,
        'image_path': imagePath,
      });
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    }
  }

  Message _toMessage(Map<String, dynamic> row) {
    return Message(
      id: row['id'] as String,
      content: row['content'] as String,
      createdAt: DateTime.parse(row['created_at'] as String),
      isMine: row['sender_id'] == _uid,
      imagePath: row['image_path'] as String?,
    );
  }
}
