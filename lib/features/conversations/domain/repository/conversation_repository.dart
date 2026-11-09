/// Contract for finding, or creating, the conversation with another user.
abstract class ConversationRepository {
  Future<String> openWith(String contactId);
}
