import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/repository/auth/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {
  void mockGetLoggedUserId({
    String? expectedLoggedUserId,
  }) {
    when(
      () => loggedUserId$,
    ).thenAnswer((_) => Stream.value(expectedLoggedUserId));
  }

  void mockSignInWithGoogle() {
    when(signInWithGoogle).thenAnswer((_) => Future.value());
  }
}
