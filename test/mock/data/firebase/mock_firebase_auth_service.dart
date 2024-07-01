import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/firebase/firebase_auth_service.dart';

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {
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
