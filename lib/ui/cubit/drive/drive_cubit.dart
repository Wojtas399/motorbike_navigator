import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../entity/coordinates.dart';
import '../../../entity/position.dart';
import '../../service/location_service.dart';
import '../../service/map_service.dart';
import 'drive_state.dart';

@injectable
class DriveCubit extends Cubit<DriveState> {
  final LocationService _locationService;
  final MapService _mapService;
  Timer? _timer;
  StreamSubscription<Position?>? _positionListener;
  List<double> _speedsInKmPerH = [];

  DriveCubit(
    this._locationService,
    this._mapService,
  ) : super(const DriveState());

  @override
  Future<void> close() {
    _timer?.cancel();
    _positionListener?.cancel();
    return super.close();
  }

  Future<void> startDrive() async {
    emit(state.copyWith(
      status: DriveStateStatus.ongoing,
    ));
    _startTimer();
    await _listenToDistanceAndSpeed();
  }

  void finishDrive() {
    _timer?.cancel();
    _positionListener?.cancel();
    _speedsInKmPerH = [];
    emit(state.copyWith(
      status: DriveStateStatus.finished,
    ));
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

  Future<void> _listenToDistanceAndSpeed() async {
    _positionListener =
        _locationService.getPosition().listen(_onPositionUpdated);
  }

  void _onPositionUpdated(Position? position) {
    if (position == null) return;
    List<Coordinates> updatedWaypoints = [...?state.waypoints];
    double distanceFromPreviousLocation = 0;
    if (updatedWaypoints.isNotEmpty) {
      distanceFromPreviousLocation = _mapService.calculateDistanceInKm(
        location1: position.coordinates,
        location2: updatedWaypoints.last,
      );
    }
    _speedsInKmPerH.add(position.speedInMetersPerSecond * 3.6);
    updatedWaypoints.add(position.coordinates);
    emit(state.copyWith(
      distanceInKm: state.distanceInKm + distanceFromPreviousLocation,
      speedInKmPerH: position.speedInMetersPerSecond * 3.6,
      avgSpeedInKmPerH: _speedsInKmPerH.average,
      waypoints: updatedWaypoints,
    ));
  }
}
