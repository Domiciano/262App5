import 'package:moviles_auth/features/auth/domain/repository/auth_repository.dart';
import 'package:moviles_auth/features/auth/domain/repository/profile_repository.dart';
import 'package:moviles_auth/features/conversations/domain/entities/contact.dart';
import 'package:moviles_auth/injection_container.dart';

/// Brings every registered user, me first and then by name.
class GetContactsUseCase {
  final AuthRepository _auth = sl();
  final ProfileRepository _profiles = sl();

  Future<List<Contact>> call() async {
    final user = _auth.currentUser();
    if (user == null) throw Exception('No hay una sesión iniciada');
    final profiles = await _profiles.getProfiles();
    final contacts = profiles
        .map(
          (profile) => Contact(profile: profile, isMe: profile.id == user.id),
        )
        .toList();
    contacts.sort((a, b) {
      if (a.isMe != b.isMe) return a.isMe ? -1 : 1;
      return a.profile.fullName.compareTo(b.profile.fullName);
    });
    return contacts;
  }
}
