abstract interface class AuthRepository {
  Stream<String?> get loggedUserId$;

  Future<void> signInWithGoogle();
}
