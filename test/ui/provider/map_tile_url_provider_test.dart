void main() {
  //TODO
  //
  // MapTileUrlProvider createProvider() =>
  //     MapTileUrlProvider();
  //
  // group(
  //   'initialize, ',
  //   () {
  //     const String loggedUserId = 'u1';
  //     final loggedUserId$ = StreamController<String?>();
  //     final loggedUser$ = StreamController<User?>();
  //
  //     blocTest(
  //       'should listen to theme mode of logged user and should update tile url '
  //       'based on it',
  //       build: () => createProvider(),
  //       setUp: () {
  //         when(
  //           () => authRepository.loggedUserId$,
  //         ).thenAnswer((_) => loggedUserId$.stream);
  //         when(
  //           () => userRepository.getUserById(userId: loggedUserId),
  //         ).thenAnswer((_) => loggedUser$.stream);
  //       },
  //       act: (cubit) {
  //         cubit.initialize();
  //         loggedUserId$.add(loggedUserId);
  //         loggedUser$.add(loggedUser1);
  //         loggedUser$.add(loggedUser2);
  //       },
  //       expect: () => [
  //         Env.mapboxTemplateUrl,
  //         Env.mapboxTemplateUrlDark,
  //       ],
  //       verify: (_) {
  //         verify(() => authRepository.loggedUserId$).called(1);
  //         verify(
  //           () => userRepository.getUserById(userId: loggedUserId),
  //         ).called(1);
  //       },
  //     );
  //   },
  // );
}
