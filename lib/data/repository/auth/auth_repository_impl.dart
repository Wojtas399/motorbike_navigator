import 'package:injectable/injectable.dart';

import '../../firebase/firebase_auth_service.dart';
import 'auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService _firebaseAuthService;

  const AuthRepositoryImpl(this._firebaseAuthService);

  @override
  Stream<String?> get loggedUserId$ => _firebaseAuthService.loggedUserId$;

  @override
  Future<void> signInWithGoogle() async {
    await _firebaseAuthService.signInWithGoogle();
  }
}
