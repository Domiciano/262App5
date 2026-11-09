import 'package:moviles_auth/features/conversations/domain/entities/contact.dart';
import 'package:moviles_auth/features/conversations/domain/entities/conversation.dart';

enum ContactsStatus { initial, loading, success, failure }

/// Single state of the contact list: the users and the conversation just opened.
class ContactsState {
  final ContactsStatus status;
  final List<Contact> contacts;
  final String? openingId;
  final Conversation? opened;
  final String? errorMessage;

  const ContactsState({
    this.status = ContactsStatus.initial,
    this.contacts = const [],
    this.openingId,
    this.opened,
    this.errorMessage,
  });

  ContactsState copyWith({
    ContactsStatus? status,
    List<Contact>? contacts,
    String? openingId,
    Conversation? opened,
    String? errorMessage,
  }) {
    return ContactsState(
      status: status ?? this.status,
      contacts: contacts ?? this.contacts,
      openingId: openingId,
      opened: opened ?? this.opened,
      errorMessage: errorMessage,
    );
  }
}
