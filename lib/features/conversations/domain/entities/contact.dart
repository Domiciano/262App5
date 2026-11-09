import 'package:moviles_auth/features/auth/domain/entities/profile.dart';

/// A registered user in the contact list, marking whether it is me.
class Contact {
  final Profile profile;
  final bool isMe;

  const Contact({required this.profile, required this.isMe});
}
