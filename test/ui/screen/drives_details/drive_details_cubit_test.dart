import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/drive.dart';
import 'package:motorbike_navigator/entity/position.dart';
import 'package:motorbike_navigator/ui/screen/drive_details/cubit/drive_details_cubit.dart';
import 'package:motorbike_navigator/ui/screen/drive_details/cubit/drive_details_state.dart';

import '../../../creator/drive_creator.dart';
import '../../../mock/data/repository/mock_drive_repository.dart';
import '../../../mock/ui_service/mock_map_service.dart';

void main() {
  final driveRepository = MockDriveRepository();
  final mapService = MockMapService();

  DriveDetailsCubit createCubit() => DriveDetailsCubit(
        driveRepository,
        mapService,
      );

  tearDown(() {
    reset(driveRepository);
    reset(mapService);
  });

  group(
    'initialize, ',
    () {
      const int driveId = 1;
      final List<Position> positions = [
        const Position(
          coordinates: Coordinates(50, 19),
          elevation: 105.25,
          speedInKmPerH: 35.5,
        ),
        const Position(
          coordinates: Coordinates(51, 20),
          elevation: 110.5,
          speedInKmPerH: 45.75,
        ),
        const Position(
          coordinates: Coordinates(52, 21),
          elevation: 115.75,
          speedInKmPerH: 55.9,
        ),
        const Position(
          coordinates: Coordinates(53, 22),
          elevation: 120.15,
          speedInKmPerH: 65,
        ),
      ];
      final Drive drive = DriveCreator(
        id: driveId,
        positions: positions,
      ).createEntity();
      const double firstToSecondPositionDistance = 10.25;
      const double secondToThirdPositionDistance = 10.5;
      const double thirdToFourthPositionDistance = 10.75;
      final List<DriveDetailsDistanceAreaChartData> expectedSpeedChartData = [
        DriveDetailsDistanceAreaChartData(
          distance: 0.0,
          value: positions.first.speedInKmPerH,
        ),
        DriveDetailsDistanceAreaChartData(
          distance: firstToSecondPositionDistance,
          value: positions[1].speedInKmPerH,
        ),
        DriveDetailsDistanceAreaChartData(
          distance:
              firstToSecondPositionDistance + secondToThirdPositionDistance,
          value: positions[2].speedInKmPerH,
        ),
        DriveDetailsDistanceAreaChartData(
          distance: firstToSecondPositionDistance +
              secondToThirdPositionDistance +
              thirdToFourthPositionDistance,
          value: positions.last.speedInKmPerH,
        ),
      ];
      final List<DriveDetailsDistanceAreaChartData> expectedElevationChartData =
          [
        DriveDetailsDistanceAreaChartData(
          distance: 0.0,
          value: positions.first.elevation,
        ),
        DriveDetailsDistanceAreaChartData(
          distance: firstToSecondPositionDistance,
          value: positions[1].elevation,
        ),
        DriveDetailsDistanceAreaChartData(
          distance:
              firstToSecondPositionDistance + secondToThirdPositionDistance,
          value: positions[2].elevation,
        ),
        DriveDetailsDistanceAreaChartData(
          distance: firstToSecondPositionDistance +
              secondToThirdPositionDistance +
              thirdToFourthPositionDistance,
          value: positions.last.elevation,
        ),
      ];

      blocTest(
        'should emit driveNotFound status if drive has not been found in '
        'DriveRepository',
        build: () => createCubit(),
        setUp: () => driveRepository.mockGetDriveById(),
        act: (cubit) async => await cubit.initialize(driveId),
        expect: () => [
          const DriveDetailsState(
            status: DriveDetailsStateStatus.driveNotFound,
          ),
        ],
      );

      blocTest(
        'should prepare area chart data for speed and elevation and should '
        'emit them',
        build: () => createCubit(),
        setUp: () {
          driveRepository.mockGetDriveById(expectedDrive: drive);
          when(
            () => mapService.calculateDistanceInKm(
              location1: positions.first.coordinates,
              location2: positions[1].coordinates,
            ),
          ).thenReturn(firstToSecondPositionDistance);
          when(
            () => mapService.calculateDistanceInKm(
              location1: positions[1].coordinates,
              location2: positions[2].coordinates,
            ),
          ).thenReturn(secondToThirdPositionDistance);
          when(
            () => mapService.calculateDistanceInKm(
              location1: positions[2].coordinates,
              location2: positions.last.coordinates,
            ),
          ).thenReturn(thirdToFourthPositionDistance);
        },
        act: (cubit) async => await cubit.initialize(driveId),
        expect: () => [
          DriveDetailsState(
            status: DriveDetailsStateStatus.completed,
            drive: drive,
            speedAreaChartData: expectedSpeedChartData,
            elevationAreaChartData: expectedElevationChartData,
          ),
        ],
      );
    },
  );
}
