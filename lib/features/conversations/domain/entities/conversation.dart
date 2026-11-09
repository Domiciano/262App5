import 'package:moviles_auth/features/auth/domain/entities/profile.dart';

/// A one-to-one conversation: its id in the conversations table and the other person.
class Conversation {
  final String id;
  final Profile contact;

  const Conversation({required this.id, required this.contact});

  @override
  String toString() {
    return 'Conversation($id con ${contact.username})';
  }
}
