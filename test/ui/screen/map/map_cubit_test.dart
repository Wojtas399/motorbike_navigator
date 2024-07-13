import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/position.dart';
import 'package:motorbike_navigator/ui/screen/map/cubit/map_cubit.dart';
import 'package:motorbike_navigator/ui/screen/map/cubit/map_state.dart';

import '../../../mock/ui_service/mock_location_service.dart';

void main() {
  final locationService = MockLocationService();

  MapCubit createCubit() => MapCubit(locationService);

  tearDown(() {
    reset(locationService);
  });

  blocTest(
    'initialize, '
    'should listen to current location and if focus mode is set to '
    'followUserLocation should assign listened location to centerLocation and '
    'userLocation params else should only assign it to userLocation param',
    build: () => createCubit(),
    setUp: () {
      when(
        locationService.getPosition,
      ).thenAnswer(
        (_) => Stream.fromIterable([
          const Position(
            coordinates: Coordinates(50, 19),
            speedInKmPerH: 10,
          ),
          const Position(
            coordinates: Coordinates(51, 20),
            speedInKmPerH: 11,
          ),
        ]),
      );
    },
    act: (cubit) async {
      cubit.initialize();
      await cubit.stream.first;
      cubit.onMapDrag(
        const Coordinates(50.5, 19.5),
      );
    },
    expect: () => [
      const MapState(
        status: MapStatus.completed,
        centerLocation: Coordinates(50, 19),
        userLocation: Coordinates(50, 19),
      ),
      const MapState(
        status: MapStatus.completed,
        focusMode: MapFocusMode.free,
        centerLocation: Coordinates(50.5, 19.5),
        userLocation: Coordinates(50, 19),
      ),
      const MapState(
        status: MapStatus.completed,
        focusMode: MapFocusMode.free,
        centerLocation: Coordinates(50.5, 19.5),
        userLocation: Coordinates(51, 20),
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
    'onMapDrag, '
    'should set focus mode as free and should update centerLocation in state',
    build: () => createCubit(),
    act: (cubit) => cubit.onMapDrag(
      const Coordinates(50.1, 18.1),
    ),
    expect: () => [
      const MapState(
        status: MapStatus.completed,
        focusMode: MapFocusMode.free,
        centerLocation: Coordinates(50.1, 18.1),
      ),
    ],
  );

  blocTest(
    'followUserLocation, '
    'userLocation is null, '
    'should do nothing',
    build: () => createCubit(),
    act: (cubit) => cubit.followUserLocation(),
    expect: () => [],
  );

  blocTest(
    'followUserLocation, '
    'userLocation is not null, '
    'should set focus mode to followUserLocation and should assign user location '
    'to centerLocation param',
    build: () => createCubit(),
    setUp: () => locationService.mockGetPosition(
      expectedPosition: const Position(
        coordinates: Coordinates(50.2, 25.4),
        speedInKmPerH: 0,
      ),
    ),
    act: (cubit) async {
      await cubit.initialize();
      cubit.onMapDrag(
        const Coordinates(50.1, 25.2),
      );
      cubit.followUserLocation();
    },
    expect: () => [
      const MapState(
        status: MapStatus.completed,
        centerLocation: Coordinates(50.2, 25.4),
        userLocation: Coordinates(50.2, 25.4),
      ),
      const MapState(
        status: MapStatus.completed,
        focusMode: MapFocusMode.free,
        centerLocation: Coordinates(50.1, 25.2),
        userLocation: Coordinates(50.2, 25.4),
      ),
      const MapState(
        status: MapStatus.completed,
        focusMode: MapFocusMode.followUserLocation,
        centerLocation: Coordinates(50.2, 25.4),
        userLocation: Coordinates(50.2, 25.4),
      ),
    ],
  );
}
