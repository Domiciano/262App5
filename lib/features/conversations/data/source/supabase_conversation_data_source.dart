import 'package:supabase_flutter/supabase_flutter.dart';

/// The only file that talks to the conversations table.
class SupabaseConversationDataSource {
  static const table = 'conversations';

  final SupabaseClient _client = Supabase.instance.client;

  Future<String> openWith(String contactId) async {
    final me = _client.auth.currentUser!.id;
    final pair = [me, contactId]..sort();
    try {
      final found = await _client
          .from(table)
          .select('id')
          .eq('user1_id', pair[0])
          .eq('user2_id', pair[1])
          .maybeSingle();
      if (found != null) return found['id'] as String;
      final created = await _client
          .from(table)
          .insert({'user1_id': pair[0], 'user2_id': pair[1]})
          .select('id')
          .single();
      return created['id'] as String;
    } on PostgrestException catch (e) {
      throw Exception(e.message);
    }
  }
}
