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

  group(
    'initialize, ',
    () {
      final List<Position> positions = [
        const Position(
          coordinates: Coordinates(50, 19),
          speedInKmPerH: 10,
        ),
        const Position(
          coordinates: Coordinates(51, 20),
          speedInKmPerH: 11,
        ),
      ];
      const Coordinates locationOnDrag = Coordinates(50.5, 19.5);
      MapState? state;

      blocTest(
        'should listen to current location and if focus mode is set to '
        'followUserLocation should assign listened location to centerLocation '
        'and userLocation params else should only assign it to userLocation '
        'param',
        build: () => createCubit(),
        setUp: () => when(
          locationService.getPosition,
        ).thenAnswer((_) => Stream.fromIterable(positions)),
        act: (cubit) async {
          cubit.initialize();
          await cubit.stream.first;
          cubit.onMapDrag(locationOnDrag);
        },
        expect: () => [
          state = MapState(
            status: MapStateStatus.completed,
            centerLocation: positions.first.coordinates,
            userLocation: positions.first.coordinates,
          ),
          state = state?.copyWith(
            focusMode: MapFocusMode.free,
            centerLocation: locationOnDrag,
          ),
          state = state?.copyWith(
            userLocation: positions.last.coordinates,
          ),
        ],
      );

      blocTest(
        'should only emit completed status if current position is null',
        setUp: () => locationService.mockGetPosition(
          expectedPosition: null,
        ),
        build: () => createCubit(),
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          const MapState(
            status: MapStateStatus.completed,
          ),
        ],
      );
    },
  );

  group(
    'onMapDrag, ',
    () {
      const Coordinates locationOnDrag = Coordinates(50.1, 18.1);

      blocTest(
        'should set focus mode as free and should update centerLocation in state',
        build: () => createCubit(),
        act: (cubit) => cubit.onMapDrag(locationOnDrag),
        expect: () => [
          const MapState(
            status: MapStateStatus.completed,
            focusMode: MapFocusMode.free,
            centerLocation: locationOnDrag,
          ),
        ],
      );
    },
  );

  blocTest(
    'stopFollowingUserLocation, '
    'should change focusMode to free',
    build: () => createCubit(),
    act: (cubit) => cubit.stopFollowingUserLocation(),
    expect: () => [
      const MapState(
        focusMode: MapFocusMode.free,
      ),
    ],
  );

  group(
    'followUserLocation, ',
    () {
      const Position position = Position(
        coordinates: Coordinates(50.2, 25.4),
        speedInKmPerH: 0,
      );
      const Coordinates locationOnDrag = Coordinates(50.1, 25.2);
      MapState? state;

      blocTest(
        'should do nothing if userLocation is null',
        build: () => createCubit(),
        act: (cubit) => cubit.followUserLocation(),
        expect: () => [],
      );

      blocTest(
        'should set focus mode as followUserLocation and should assign user '
        'location to centerLocation param',
        build: () => createCubit(),
        setUp: () => locationService.mockGetPosition(
          expectedPosition: position,
        ),
        act: (cubit) async {
          await cubit.initialize();
          cubit.onMapDrag(locationOnDrag);
          cubit.followUserLocation();
        },
        expect: () => [
          state = MapState(
            status: MapStateStatus.completed,
            centerLocation: position.coordinates,
            userLocation: position.coordinates,
          ),
          state = state?.copyWith(
            focusMode: MapFocusMode.free,
            centerLocation: locationOnDrag,
          ),
          state = state?.copyWith(
            focusMode: MapFocusMode.followUserLocation,
            centerLocation: position.coordinates,
          ),
        ],
      );
    },
  );

  blocTest(
    'changeMode, '
    'should update mode in state',
    build: () => createCubit(),
    act: (cubit) => cubit.changeMode(MapMode.selectingRoute),
    expect: () => [
      const MapState(
        status: MapStateStatus.completed,
        mode: MapMode.selectingRoute,
      ),
    ],
  );
}
