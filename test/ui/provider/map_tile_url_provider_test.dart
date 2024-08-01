import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/user.dart';
import 'package:motorbike_navigator/env.dart';
import 'package:motorbike_navigator/ui/provider/map_tile_url_provider.dart';

import '../../mock/data/repository/mock_auth_repository.dart';
import '../../mock/data/repository/mock_user_repository.dart';

void main() {
  final authRepository = MockAuthRepository();
  final userRepository = MockUserRepository();

  MapTileUrlProvider createProvider() =>
      MapTileUrlProvider(authRepository, userRepository);

  tearDown(() {
    reset(authRepository);
    reset(userRepository);
  });

  group(
    'initialize, ',
    () {
      const String loggedUserId = 'u1';
      const User loggedUser1 = User(
        id: loggedUserId,
        themeMode: ThemeMode.light,
      );
      const User loggedUser2 = User(
        id: loggedUserId,
        themeMode: ThemeMode.dark,
      );
      final loggedUserId$ = StreamController<String?>();
      final loggedUser$ = StreamController<User?>();

      blocTest(
        'should listen to theme mode of logged user and should update tile url '
        'based on it',
        build: () => createProvider(),
        setUp: () {
          when(
            () => authRepository.loggedUserId$,
          ).thenAnswer((_) => loggedUserId$.stream);
          when(
            () => userRepository.getUserById(userId: loggedUserId),
          ).thenAnswer((_) => loggedUser$.stream);
        },
        act: (cubit) {
          cubit.initialize();
          loggedUserId$.add(loggedUserId);
          loggedUser$.add(loggedUser1);
          loggedUser$.add(loggedUser2);
        },
        expect: () => [
          Env.mapboxTemplateUrl,
          Env.mapboxTemplateUrlDark,
        ],
        verify: (_) {
          verify(() => authRepository.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
        },
      );
    },
  );
}
