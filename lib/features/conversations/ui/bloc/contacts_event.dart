import 'package:moviles_auth/features/auth/domain/entities/profile.dart';

/// Something the contacts screen asks the ContactsBloc to do.
abstract class ContactsEvent {}

/// The contacts screen opened: load the registered users.
class ContactsStarted extends ContactsEvent {}

/// The user tapped a contact: open the conversation with them.
class ContactSelected extends ContactsEvent {
  final Profile contact;

  ContactSelected(this.contact);
}
