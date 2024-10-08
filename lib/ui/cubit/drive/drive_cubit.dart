import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/repository/drive/drive_repository.dart';
import '../../../entity/position.dart';
import '../../service/date_service.dart';
import '../../service/drive_service.dart';
import '../../service/location_service.dart';
import '../../service/map_service.dart';
import 'drive_state.dart';

@injectable
class DriveCubit extends Cubit<DriveState> {
  final LocationService _locationService;
  final MapService _mapService;
  final DriveRepository _driveRepository;
  final DateService _dateService;
  final DriveService _driveService;
  Timer? _timer;
  StreamSubscription<Position?>? _positionListener;
  StreamSubscription<LocationStatus>? _locationStatusListener;

  DriveCubit(
    this._locationService,
    this._mapService,
    this._driveRepository,
    this._dateService,
    this._driveService,
  ) : super(const DriveState());

  @override
  Future<void> close() {
    _timer?.cancel();
    _positionListener?.cancel();
    _locationStatusListener?.cancel();
    return super.close();
  }

  void startDrive({
    required Position? startPosition,
  }) {
    if (startPosition == null) return;
    emit(state.copyWith(
      status: DriveStateStatus.ongoing,
      startDatetime: _dateService.getNow(),
      speedInKmPerH: startPosition.speedInKmPerH,
      avgSpeedInKmPerH: startPosition.speedInKmPerH,
      positions: [startPosition],
    ));
    _startTimer();
    _listenPosition();
    _listenLocationStatus();
  }

  void pauseDrive() {
    _timer?.cancel();
    _positionListener?.cancel();
    _timer = null;
    _positionListener = null;
    emit(state.copyWith(
      status: DriveStateStatus.paused,
    ));
  }

  void resumeDrive() {
    emit(state.copyWith(
      status: DriveStateStatus.ongoing,
    ));
    _startTimer();
    _listenPosition();
  }

  Future<void> saveDrive() async {
    if (state.status != DriveStateStatus.paused ||
        state.startDatetime == null) {
      return;
    }
    emit(state.copyWith(
      status: DriveStateStatus.saving,
    ));
    await _driveRepository.addDrive(
      title: _driveService.getDefaultTitle(),
      startDateTime: state.startDatetime!,
      distanceInKm: state.distanceInKm,
      duration: state.duration,
      positions: state.positions,
    );
    emit(state.copyWith(
      status: DriveStateStatus.saved,
    ));
  }

  void resetDrive() {
    emit(const DriveState());
  }

  void _startTimer() {
    _timer ??= Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        emit(state.copyWith(
          status: DriveStateStatus.ongoing,
          duration: Duration(seconds: state.duration.inSeconds + 1),
        ));
      },
    );
  }

  void _listenPosition() {
    _positionListener ??=
        _locationService.getPosition().listen(_handlePositionChange);
  }

  void _listenLocationStatus() {
    _locationStatusListener ??= _locationService
        .getLocationStatus()
        .listen(_handleLocationStatusChange);
  }

  void _handlePositionChange(Position? position) {
    if (position == null) return;
    List<Position> updatedPositions = [...state.positions];
    double distanceFromPreviousLocation = 0;
    if (updatedPositions.isNotEmpty) {
      distanceFromPreviousLocation = _mapService.calculateDistanceInKm(
        location1: updatedPositions.last.coordinates,
        location2: position.coordinates,
      );
    }
    updatedPositions.add(position);
    final double avgSpeed = updatedPositions
        .map((Position position) => position.speedInKmPerH)
        .average;
    emit(state.copyWith(
      status: DriveStateStatus.ongoing,
      distanceInKm: state.distanceInKm + distanceFromPreviousLocation,
      speedInKmPerH: position.speedInKmPerH,
      avgSpeedInKmPerH: avgSpeed,
      positions: updatedPositions,
    ));
  }

  void _handleLocationStatusChange(LocationStatus status) {
    if (status == LocationStatus.off &&
        state.status == DriveStateStatus.ongoing) {
      pauseDrive();
    }
  }
}
