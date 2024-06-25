import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/position.dart';
import 'package:motorbike_navigator/ui/cubit/map/map_cubit.dart';
import 'package:motorbike_navigator/ui/cubit/map/map_state.dart';

import '../../mock/ui_service/mock_location_service.dart';

void main() {
  final locationService = MockLocationService();

  MapCubit createCubit() => MapCubit(locationService);

  tearDown(() {
    reset(locationService);
  });

  blocTest(
    'initialize, '
    'should get coordinates of current position got form LocationService '
    'and should assign it to centerLocation and userLocation params',
    setUp: () => locationService.mockGetPosition(
      expectedPosition: const Position(
        coordinates: Coordinates(50.2, 25.4),
        speedInMetersPerSecond: 0,
      ),
    ),
    build: () => createCubit(),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const MapState(
        status: MapStatus.completed,
        centerLocation: Coordinates(50.2, 25.4),
        userLocation: Coordinates(50.2, 25.4),
      ),
    ],
  );

  blocTest(
    'initialize, '
    'current position is null, '
    'should only emit completed status',
    setUp: () => locationService.mockGetPosition(
      expectedPosition: null,
    ),
    build: () => createCubit(),
    act: (cubit) async => await cubit.initialize(),
    expect: () => [
      const MapState(
        status: MapStatus.completed,
      ),
    ],
  );

  blocTest(
    'onCenterLocationChanged, '
    'should update centerLocation in state',
    build: () => createCubit(),
    act: (cubit) => cubit.onCenterLocationChanged(
      const Coordinates(50.1, 18.1),
    ),
    expect: () => [
      const MapState(
        status: MapStatus.completed,
        centerLocation: Coordinates(50.1, 18.1),
      ),
    ],
  );
}
