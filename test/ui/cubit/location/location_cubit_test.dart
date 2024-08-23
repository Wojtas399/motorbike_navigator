import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/ui/cubit/location/location_cubit.dart';
import 'package:motorbike_navigator/ui/cubit/location/location_state.dart';
import 'package:motorbike_navigator/ui/service/location_service.dart';
import 'package:rxdart/rxdart.dart';

import '../../../mock/ui_service/mock_location_service.dart';

void main() {
  final locationService = MockLocationService();

  LocationCubit createCubit() => LocationCubit(locationService);

  tearDown(() {
    reset(locationService);
  });

  group(
    'listenToLocationStatus, ',
    () {
      final locationStatus$ =
          BehaviorSubject<LocationStatus>.seeded(LocationStatus.on);

      blocTest(
        'should emit LocationStateAccessDenied if location access has been denied',
        build: () => createCubit(),
        setUp: () => locationService.mockHasPermission(expected: false),
        act: (cubit) async => await cubit.listenToLocationStatus(),
        expect: () => [
          const LocationStateAccessDenied(),
        ],
        verify: (_) => verify(locationService.hasPermission).called(1),
      );

      blocTest(
        'should listen to location status and should emit LocationStateOn if '
        'location is on and LocationStateOff if location is off',
        build: () => createCubit(),
        setUp: () {
          locationService.mockHasPermission(expected: true);
          when(
            locationService.getLocationStatus,
          ).thenAnswer((_) => locationStatus$.stream);
        },
        act: (cubit) async {
          await cubit.listenToLocationStatus();
          locationStatus$.add(LocationStatus.off);
        },
        expect: () => [
          const LocationStateOn(),
          const LocationStateOff(),
        ],
        verify: (_) {
          verify(locationService.hasPermission).called(1);
          verify(locationService.getLocationStatus).called(1);
        },
      );
    },
  );
}
