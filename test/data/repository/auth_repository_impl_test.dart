import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/repository/auth/auth_repository_impl.dart';

import '../../mock/data/firebase/mock_firebase_auth_service.dart';

void main() {
  final dbAuthService = MockFirebaseAuthService();
  late AuthRepositoryImpl repositoryImpl;

  setUp(() {
    repositoryImpl = AuthRepositoryImpl(dbAuthService);
  });

  tearDown(() {
    reset(dbAuthService);
  });

  test(
    'loggedUserId, '
    'should emit id of logged user got from firebase',
    () {
      const String id = 'u1';
      dbAuthService.mockGetLoggedUserId(expectedLoggedUserId: id);

      final Stream<String?> loggedUserId$ = repositoryImpl.loggedUserId$;

      expect(loggedUserId$, emits(id));
    },
  );

  test(
    'signInWithGoogle, '
    'should call method from db to sign in with google',
    () async {
      dbAuthService.mockSignInWithGoogle();

      await repositoryImpl.signInWithGoogle();

      verify(dbAuthService.signInWithGoogle).called(1);
    },
  );
}
