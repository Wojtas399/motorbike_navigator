import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/position.dart';
import 'package:motorbike_navigator/ui/screen/map/cubit/map_cubit.dart';
import 'package:motorbike_navigator/ui/screen/map/cubit/map_state.dart';
import 'package:motorbike_navigator/ui/service/location_service.dart';
import 'package:rxdart/rxdart.dart';

import '../../../mock/ui_service/mock_device_settings_service.dart';
import '../../../mock/ui_service/mock_location_service.dart';

void main() {
  final locationService = MockLocationService();
  final deviceSettingsService = MockDeviceSettingsService();

  MapCubit createCubit() => MapCubit(
        locationService,
        deviceSettingsService,
      );

  tearDown(() {
    reset(locationService);
    reset(deviceSettingsService);
  });

  group(
    'initialize, ',
    () {
      final List<Position> positions = [
        const Position(
          coordinates: Coordinates(50, 19),
          altitude: 120.2,
          speedInKmPerH: 10,
        ),
        const Position(
          coordinates: Coordinates(51, 20),
          altitude: 119.4,
          speedInKmPerH: 11,
        ),
      ];
      const Coordinates locationOnDrag = Coordinates(50.5, 19.5);
      final positionStream$ =
          BehaviorSubject<Position?>.seeded(positions.first);
      MapState? state;

      blocTest(
        'should emit locationIsOff status if location status is set as off',
        build: () => createCubit(),
        setUp: () => locationService.mockGetLocationStatus(
          expectedLocationStatus: LocationStatus.off,
        ),
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          const MapState(
            status: MapStateStatus.locationIsOff,
          ),
        ],
      );

      blocTest(
        'should emit locationAccessDenied status if location is on but location '
        'permission is denied',
        build: () => createCubit(),
        setUp: () {
          locationService.mockGetLocationStatus(
            expectedLocationStatus: LocationStatus.on,
          );
          locationService.mockHasPermission(expected: false);
        },
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          const MapState(
            status: MapStateStatus.locationAccessDenied,
          ),
        ],
      );

      blocTest(
        'should listen to current position and if focus mode is set to '
        'followUserLocation should assign listened position to centerLocation '
        'and userPosition params else should only assign it to userPosition '
        'param',
        build: () => createCubit(),
        setUp: () {
          locationService.mockGetLocationStatus(
            expectedLocationStatus: LocationStatus.on,
          );
          locationService.mockHasPermission(expected: true);
          when(
            locationService.getPosition,
          ).thenAnswer((_) => positionStream$.stream);
        },
        act: (cubit) async {
          cubit.initialize();
          await cubit.stream.first;
          positionStream$.add(null);
          cubit.onMapDrag(locationOnDrag);
          positionStream$.add(positions.last);
        },
        expect: () => [
          state = MapState(
            status: MapStateStatus.completed,
            centerLocation: positions.first.coordinates,
            userPosition: positions.first,
          ),
          state = state?.copyWith(
            focusMode: MapFocusMode.free,
            centerLocation: locationOnDrag,
          ),
          state = state?.copyWith(
            userPosition: positions.last,
          ),
        ],
      );
    },
  );

  group(
    'refreshLocationPermission, ',
    () {
      final List<Position> positions = [
        const Position(
          coordinates: Coordinates(50, 19),
          altitude: 120.2,
          speedInKmPerH: 10,
        ),
        const Position(
          coordinates: Coordinates(51, 20),
          altitude: 119.4,
          speedInKmPerH: 11,
        ),
      ];
      MapState? state;

      blocTest(
        'should emit locationAccessDenied status if location permission is denied',
        build: () => createCubit(),
        setUp: () => locationService.mockHasPermission(expected: false),
        act: (cubit) async => await cubit.refreshLocationPermission(),
        expect: () => [
          const MapState(
            status: MapStateStatus.loading,
          ),
          const MapState(
            status: MapStateStatus.locationAccessDenied,
          ),
        ],
        verify: (_) => verify(locationService.hasPermission).called(1),
      );

      blocTest(
        'should start listening to current position if location permission is '
        'granted',
        build: () => createCubit(),
        setUp: () {
          locationService.mockHasPermission(expected: true);
          when(
            locationService.getPosition,
          ).thenAnswer((_) => Stream.fromIterable(positions));
        },
        act: (cubit) async => await cubit.refreshLocationPermission(),
        expect: () => [
          state = const MapState(
            status: MapStateStatus.loading,
          ),
          state = state?.copyWith(
            status: MapStateStatus.completed,
            centerLocation: positions.first.coordinates,
            userPosition: positions.first,
          ),
          state = state?.copyWith(
            centerLocation: positions.last.coordinates,
            userPosition: positions.last,
          ),
        ],
        verify: (_) => verify(locationService.hasPermission).called(1),
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
        altitude: 100.22,
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
        'position to centerLocation param',
        build: () => createCubit(),
        setUp: () {
          locationService.mockGetLocationStatus(
            expectedLocationStatus: LocationStatus.on,
          );
          locationService.mockHasPermission(expected: true);
          locationService.mockGetPosition(
            expectedPosition: position,
          );
        },
        act: (cubit) async {
          await cubit.initialize();
          await cubit.stream.first;
          cubit.onMapDrag(locationOnDrag);
          cubit.followUserLocation();
        },
        expect: () => [
          state = MapState(
            status: MapStateStatus.completed,
            centerLocation: position.coordinates,
            userPosition: position,
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

  blocTest(
    'openLocationSettings, '
    'should call method from DeviceSettingService to open location settings',
    build: () => createCubit(),
    act: (cubit) => cubit.openLocationSettings(),
    verify: (_) => verify(deviceSettingsService.openLocationSettings).called(1),
  );
}
