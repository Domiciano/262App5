import 'package:moviles_auth/features/auth/domain/entities/profile.dart';
import 'package:moviles_auth/features/conversations/domain/entities/conversation.dart';
import 'package:moviles_auth/features/conversations/domain/repository/conversation_repository.dart';
import 'package:moviles_auth/injection_container.dart';

/// Loads the conversation with a contact, creating it the first time.
class OpenConversationUseCase {
  final ConversationRepository _conversations = sl();

  Future<Conversation> call(Profile contact) async {
    final id = await _conversations.openWith(contact.id);
    return Conversation(id: id, contact: contact);
  }
}
