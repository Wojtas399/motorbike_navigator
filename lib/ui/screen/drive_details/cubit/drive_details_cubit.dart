import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/repository/drive/drive_repository.dart';
import '../../../../entity/drive.dart';
import '../../../../entity/position.dart';
import '../../../service/map_service.dart';
import 'drive_details_state.dart';

@injectable
class DriveDetailsCubit extends Cubit<DriveDetailsState> {
  final DriveRepository _driveRepository;
  final MapService _mapService;

  DriveDetailsCubit(
    this._driveRepository,
    this._mapService,
  ) : super(const DriveDetailsState());

  Future<void> initialize(int driveId) async {
    final Stream<Drive?> drive$ = _driveRepository.getDriveById(driveId);
    await for (final drive in drive$) {
      if (drive != null) {
        _initializeDriveDetails(drive);
      } else {
        emit(state.copyWith(
          status: DriveDetailsStateStatus.driveNotFound,
        ));
      }
    }
  }

  void _initializeDriveDetails(Drive drive) {
    final List<Position> positions = drive.positions;
    if (positions.isEmpty) {
      emit(state.copyWith(
        status: DriveDetailsStateStatus.completed,
        drive: drive,
      ));
      return;
    }
    List<DriveDetailsDistanceAreaChartData> speedAreaChartData = [];
    List<DriveDetailsDistanceAreaChartData> elevationAreaChartData = [];
    double distance = 0.0;
    for (int i = 0; i < positions.length; i++) {
      speedAreaChartData.add(DriveDetailsDistanceAreaChartData(
        distance: distance,
        value: positions[i].speedInKmPerH,
      ));
      elevationAreaChartData.add(DriveDetailsDistanceAreaChartData(
        distance: distance,
        value: positions[i].altitude,
      ));
      if (i < positions.length - 1) {
        distance += _mapService.calculateDistanceInKm(
          location1: positions[i].coordinates,
          location2: positions[i + 1].coordinates,
        );
      }
    }
    emit(state.copyWith(
      status: DriveDetailsStateStatus.completed,
      drive: drive,
      speedAreaChartData: speedAreaChartData,
      elevationAreaChartData: elevationAreaChartData,
    ));
  }
}
