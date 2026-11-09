import 'package:moviles_auth/features/conversations/data/source/supabase_conversation_data_source.dart';
import 'package:moviles_auth/features/conversations/domain/repository/conversation_repository.dart';
import 'package:moviles_auth/injection_container.dart';

/// Fulfils ConversationRepository with the conversations table.
class ConversationRepositoryImpl implements ConversationRepository {
  final SupabaseConversationDataSource _dataSource = sl();

  @override
  Future<String> openWith(String contactId) {
    return _dataSource.openWith(contactId);
  }
}
