import 'package:moviles_auth/features/auth/domain/entities/profile.dart';
import 'package:moviles_auth/features/auth/domain/repository/auth_repository.dart';
import 'package:moviles_auth/features/auth/domain/repository/profile_repository.dart';
import 'package:moviles_auth/injection_container.dart';

/// Reads the user saved in the local session and brings their profile.
class GetMyProfileUseCase {
  final AuthRepository _auth = sl();
  final ProfileRepository _profiles = sl();

  Future<Profile> call() async {
    final user = _auth.currentUser();
    if (user == null) throw Exception('No hay una sesión iniciada');
    return _profiles.getProfile(user.id);
  }
}
