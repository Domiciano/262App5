import 'package:moviles_auth/features/auth/domain/repository/auth_repository.dart';
import 'package:moviles_auth/injection_container.dart';

/// Closes the current session.
class SignOutUseCase {
  final AuthRepository _auth = sl();

  Future<void> call() {
    return _auth.signOut();
  }
}
