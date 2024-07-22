import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/map_point.dart';
import 'package:motorbike_navigator/entity/navigation.dart';
import 'package:motorbike_navigator/ui/cubit/route/route_cubit.dart';
import 'package:motorbike_navigator/ui/cubit/route/route_state.dart';

import '../../../creator/place_creator.dart';
import '../../../mock/data/repository/mock_navigation_repository.dart';
import '../../../mock/data/repository/mock_place_repository.dart';
import '../../../mock/ui_service/mock_location_service.dart';

void main() {
  final locationService = MockLocationService();
  final placeRepository = MockPlaceRepository();
  final navigationRepository = MockNavigationRepository();
  final placeCreator = PlaceCreator();

  RouteCubit createCubit() => RouteCubit(
        locationService,
        placeRepository,
        navigationRepository,
      );

  tearDown(
    () {
      reset(locationService);
      reset(placeRepository);
    },
  );

  group(
    'onStartPointChanged, ',
    () {
      const MapPoint expectedStartPoint = SelectedPlacePoint(
        id: 'p1',
        name: 'place 1',
      );

      blocTest(
        'should update startPoint and should set status as infill',
        build: () => createCubit(),
        act: (cubit) => cubit.onStartPointChanged(expectedStartPoint),
        expect: () => [
          const RouteState(
            status: RouteStateStatus.infill,
            startPoint: expectedStartPoint,
          ),
        ],
      );
    },
  );

  group(
    'onEndPointChanged, ',
    () {
      const MapPoint expectedEndPoint = SelectedPlacePoint(
        id: 'p1',
        name: 'place suggestion',
      );

      blocTest(
        'should update endPoint and should set status as infill',
        build: () => createCubit(),
        act: (cubit) => cubit.onEndPointChanged(expectedEndPoint),
        expect: () => [
          const RouteState(
            status: RouteStateStatus.infill,
            endPoint: expectedEndPoint,
          ),
        ],
      );
    },
  );

  group(
    'swapPoints, ',
    () {
      const MapPoint defaultStartPoint = UserLocationPoint();
      const MapPoint endPoint = SelectedPlacePoint(
        id: 'p2',
        name: 'destination',
      );
      RouteState? state;

      blocTest(
        'should swap values of startPoint and endPoint',
        build: () => createCubit(),
        act: (cubit) {
          cubit.onEndPointChanged(endPoint);
          cubit.swapPoints();
        },
        expect: () => [
          state = const RouteState(
            status: RouteStateStatus.infill,
            endPoint: endPoint,
          ),
          state = state?.copyWith(
            startPoint: endPoint,
            endPoint: defaultStartPoint,
          ),
        ],
      );
    },
  );

  group(
    'loadNavigation, ',
    () {
      const startPoint = UserLocationPoint();
      const endPoint = SelectedPlacePoint(id: 'p2', name: 'place 2');
      const startLocation = Coordinates(50.1, 18.1);
      const endLocation = Coordinates(51.2, 19.2);
      final navigation = Navigation(
        startLocation: startLocation,
        endLocation: endLocation,
        routes: const [
          Route(
            duration: Duration(minutes: 10),
            distanceInMeters: 1000.1,
            waypoints: [
              Coordinates(50.25, 18.25),
              Coordinates(50.5, 18.5),
            ],
          ),
          Route(
            duration: Duration(minutes: 20),
            distanceInMeters: 2000.2,
            waypoints: [
              Coordinates(50.25, 18.25),
              Coordinates(50.5, 18.5),
            ],
          ),
        ],
      );
      RouteState? state;

      blocTest(
        'should emit status set as formNotCompleted if endPoint is null',
        build: () => createCubit(),
        act: (cubit) async => await cubit.loadNavigation(),
        expect: () => [
          state = const RouteState(
            status: RouteStateStatus.formNotCompleted,
          ),
        ],
      );

      blocTest(
        'should emit status set as formNotCompleted if startPoint is null',
        build: () => createCubit(),
        act: (cubit) async {
          cubit.swapPoints();
          await cubit.loadNavigation();
        },
        expect: () => [
          state = const RouteState(
            status: RouteStateStatus.infill,
            startPoint: null,
            endPoint: startPoint,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.formNotCompleted,
          ),
        ],
      );

      blocTest(
        'should emit status set as pointsMustBeDifferent if start and end '
        'points are the same',
        build: () => createCubit(),
        act: (cubit) async {
          cubit.onEndPointChanged(startPoint);
          await cubit.loadNavigation();
        },
        expect: () => [
          state = const RouteState(
            status: RouteStateStatus.infill,
            endPoint: startPoint,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.pointsMustBeDifferent,
          ),
        ],
      );

      blocTest(
        'should finish method call if location of start point has not been found',
        build: () => createCubit(),
        setUp: () {
          locationService.mockLoadLocation();
          placeRepository.mockGetPlaceById(
            result: placeCreator.create(coordinates: endLocation),
          );
        },
        act: (cubit) async {
          cubit.onEndPointChanged(endPoint);
          await cubit.loadNavigation();
        },
        expect: () => [
          state = const RouteState(
            status: RouteStateStatus.infill,
            endPoint: endPoint,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.searching,
          ),
        ],
        verify: (_) {
          verify(locationService.loadLocation).called(1);
          verify(
            () => placeRepository.getPlaceById(endPoint.id),
          ).called(1);
        },
      );

      blocTest(
        'should finish method call if location of end point has not been found',
        build: () => createCubit(),
        setUp: () {
          locationService.mockLoadLocation(
            expectedLocation: startLocation,
          );
          placeRepository.mockGetPlaceById();
        },
        act: (cubit) async {
          cubit.onEndPointChanged(endPoint);
          await cubit.loadNavigation();
        },
        expect: () => [
          state = const RouteState(
            status: RouteStateStatus.infill,
            endPoint: endPoint,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.searching,
          ),
        ],
        verify: (_) {
          verify(locationService.loadLocation).called(1);
          verify(
            () => placeRepository.getPlaceById(endPoint.id),
          ).called(1);
        },
      );

      blocTest(
        'should emit routeNotFound status if navigation has not been found',
        build: () => createCubit(),
        setUp: () {
          locationService.mockLoadLocation(
            expectedLocation: startLocation,
          );
          placeRepository.mockGetPlaceById(
            result: placeCreator.create(coordinates: endLocation),
          );
          navigationRepository.mockLoadNavigationByStartAndEndLocations(
            navigation: null,
          );
        },
        act: (cubit) async {
          cubit.onEndPointChanged(endPoint);
          await cubit.loadNavigation();
        },
        expect: () => [
          state = const RouteState(
            status: RouteStateStatus.infill,
            endPoint: endPoint,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.searching,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.routeNotFound,
          ),
        ],
        verify: (_) {
          verify(locationService.loadLocation).called(1);
          verify(
            () => placeRepository.getPlaceById(endPoint.id),
          ).called(1);
          verify(
            () => navigationRepository.loadNavigationByStartAndEndLocations(
              startLocation: startLocation,
              endLocation: endLocation,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should emit routeNotFound status if found navigation does not contain '
        'any routes',
        build: () => createCubit(),
        setUp: () {
          locationService.mockLoadLocation(
            expectedLocation: startLocation,
          );
          placeRepository.mockGetPlaceById(
            result: placeCreator.create(coordinates: endLocation),
          );
          navigationRepository.mockLoadNavigationByStartAndEndLocations(
            navigation: Navigation(
              startLocation: startLocation,
              endLocation: endLocation,
              routes: const [],
            ),
          );
        },
        act: (cubit) async {
          cubit.onEndPointChanged(endPoint);
          await cubit.loadNavigation();
        },
        expect: () => [
          state = const RouteState(
            status: RouteStateStatus.infill,
            endPoint: endPoint,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.searching,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.routeNotFound,
          ),
        ],
        verify: (_) {
          verify(locationService.loadLocation).called(1);
          verify(
            () => placeRepository.getPlaceById(endPoint.id),
          ).called(1);
          verify(
            () => navigationRepository.loadNavigationByStartAndEndLocations(
              startLocation: startLocation,
              endLocation: endLocation,
            ),
          ).called(1);
        },
      );

      blocTest(
        'should load coordinates of start and end points, should load '
        'routes between these two locations and should emit first of the found '
        'routes',
        build: () => createCubit(),
        setUp: () {
          locationService.mockLoadLocation(
            expectedLocation: startLocation,
          );
          placeRepository.mockGetPlaceById(
            result: placeCreator.create(coordinates: endLocation),
          );
          navigationRepository.mockLoadNavigationByStartAndEndLocations(
            navigation: navigation,
          );
        },
        act: (cubit) async {
          cubit.onEndPointChanged(endPoint);
          await cubit.loadNavigation();
        },
        expect: () => [
          state = const RouteState(
            status: RouteStateStatus.infill,
            endPoint: endPoint,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.searching,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.routeFound,
            route: navigation.routes.first,
          ),
        ],
        verify: (_) {
          verify(locationService.loadLocation).called(1);
          verify(
            () => placeRepository.getPlaceById(endPoint.id),
          ).called(1);
          verify(
            () => navigationRepository.loadNavigationByStartAndEndLocations(
              startLocation: startLocation,
              endLocation: endLocation,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'resetRoute, ',
    () {
      const endPoint = SelectedPlacePoint(id: 'p2', name: 'place 2');
      const startLocation = Coordinates(50.1, 18.1);
      const endLocation = Coordinates(51.2, 19.2);
      final navigation = Navigation(
        startLocation: startLocation,
        endLocation: endLocation,
        routes: const [
          Route(
            duration: Duration(minutes: 10),
            distanceInMeters: 1000.1,
            waypoints: [
              Coordinates(50.25, 18.25),
              Coordinates(50.5, 18.5),
            ],
          ),
        ],
      );
      RouteState? state;

      blocTest(
        'should set status as infill and route as null',
        build: () => createCubit(),
        setUp: () {
          locationService.mockLoadLocation(
            expectedLocation: startLocation,
          );
          placeRepository.mockGetPlaceById(
            result: placeCreator.create(coordinates: endLocation),
          );
          navigationRepository.mockLoadNavigationByStartAndEndLocations(
            navigation: navigation,
          );
        },
        act: (cubit) async {
          cubit.onEndPointChanged(endPoint);
          await cubit.loadNavigation();
          cubit.resetRoute();
        },
        expect: () => [
          state = const RouteState(
            status: RouteStateStatus.infill,
            endPoint: endPoint,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.searching,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.routeFound,
            route: navigation.routes.first,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.infill,
            route: null,
          ),
        ],
      );
    },
  );

  group(
    'reset, ',
    () {
      const endPoint = SelectedPlacePoint(id: 'p2', name: 'place 2');
      const startLocation = Coordinates(50.1, 18.1);
      const endLocation = Coordinates(51.2, 19.2);
      final navigation = Navigation(
        startLocation: startLocation,
        endLocation: endLocation,
        routes: const [
          Route(
            duration: Duration(minutes: 10),
            distanceInMeters: 1000.1,
            waypoints: [
              Coordinates(50.25, 18.25),
              Coordinates(50.5, 18.5),
            ],
          ),
        ],
      );
      RouteState? state;

      blocTest(
        'should set default state',
        build: () => createCubit(),
        setUp: () {
          locationService.mockLoadLocation(
            expectedLocation: startLocation,
          );
          placeRepository.mockGetPlaceById(
            result: placeCreator.create(coordinates: endLocation),
          );
          navigationRepository.mockLoadNavigationByStartAndEndLocations(
            navigation: navigation,
          );
        },
        act: (cubit) async {
          cubit.onEndPointChanged(endPoint);
          await cubit.loadNavigation();
          cubit.reset();
        },
        expect: () => [
          state = const RouteState(
            status: RouteStateStatus.infill,
            endPoint: endPoint,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.searching,
          ),
          state = state?.copyWith(
            status: RouteStateStatus.routeFound,
            route: navigation.routes.first,
          ),
          const RouteState(),
        ],
      );
    },
  );
}
