import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/repository/auth/auth_repository.dart';
import '../../../data/repository/drive/drive_repository.dart';
import '../../../entity/coordinates.dart';
import '../../../entity/position.dart';
import '../../service/date_service.dart';
import '../../service/location_service.dart';
import '../../service/map_service.dart';
import 'drive_state.dart';

@injectable
class DriveCubit extends Cubit<DriveState> {
  final LocationService _locationService;
  final MapService _mapService;
  final AuthRepository _authRepository;
  final DriveRepository _driveRepository;
  final DateService _dateService;
  Timer? _timer;
  StreamSubscription<Position?>? _positionListener;
  List<double> _speedsInKmPerH = [];

  DriveCubit(
    this._locationService,
    this._mapService,
    this._authRepository,
    this._driveRepository,
    this._dateService,
  ) : super(const DriveState());

  @override
  Future<void> close() {
    _timer?.cancel();
    _positionListener?.cancel();
    return super.close();
  }

  void startDrive({
    required Coordinates? startLocation,
  }) {
    if (startLocation == null) return;
    emit(state.copyWith(
      status: DriveStateStatus.ongoing,
      startDatetime: _dateService.getNow(),
      waypoints: [startLocation],
    ));
    _startTimer();
    _listenPosition();
  }

  void finishDrive() {
    _timer?.cancel();
    _positionListener?.cancel();
    _speedsInKmPerH = [];
    emit(state.copyWith(
      status: DriveStateStatus.finished,
      endDateTime: _dateService.getNow(),
    ));
  }

  Future<void> saveDrive() async {
    if (state.status != DriveStateStatus.finished) return;
    final String? loggedUserId = await _authRepository.loggedUserId$.first;
    if (loggedUserId == null) {
      throw '[DriveCubit] Cannot find logged user';
    }
    emit(state.copyWith(
      status: DriveStateStatus.saving,
    ));
    await _driveRepository.addDrive(
      userId: loggedUserId,
      startDateTime: DateTime(2024, 7, 10, 9, 28),
      endDateTime: DateTime(2024, 7, 10, 10, 30),
      distanceInKm: state.distanceInKm,
      durationInSeconds: state.duration.inSeconds,
      avgSpeedInKmPerH: state.avgSpeedInKmPerH,
      waypoints: state.waypoints,
    );
    emit(state.copyWith(
      status: DriveStateStatus.saved,
    ));
  }

  void resetDrive() {
    emit(const DriveState());
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        emit(state.copyWith(
          duration: Duration(seconds: state.duration.inSeconds + 1),
        ));
      },
    );
  }

  void _listenPosition() {
    _positionListener =
        _locationService.getPosition().listen(_onPositionUpdated);
  }

  void _onPositionUpdated(Position? position) {
    if (position == null) return;
    List<Coordinates> updatedWaypoints = [...state.waypoints];
    double distanceFromPreviousLocation = 0;
    if (updatedWaypoints.isNotEmpty) {
      distanceFromPreviousLocation = _mapService.calculateDistanceInKm(
        location1: updatedWaypoints.last,
        location2: position.coordinates,
      );
    }
    updatedWaypoints.add(position.coordinates);
    _speedsInKmPerH.add(position.speedInMetersPerSecond * 3.6);
    emit(state.copyWith(
      distanceInKm: state.distanceInKm + distanceFromPreviousLocation,
      speedInKmPerH: position.speedInMetersPerSecond * 3.6,
      avgSpeedInKmPerH: _speedsInKmPerH.average,
      waypoints: updatedWaypoints,
    ));
  }
}
