import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../entity/coordinates.dart';
import '../../service/location_service.dart';
import '../../service/map_service.dart';
import 'drive_state.dart';

@injectable
class DriveCubit extends Cubit<DriveState> {
  final LocationService _locationService;
  final MapService _mapService;
  Timer? _timer;

  DriveCubit(
    this._locationService,
    this._mapService,
  ) : super(const DriveState());

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> startDrive() async {
    emit(state.copyWith(
      status: DriveStateStatus.ongoing,
    ));
    _startTimer();
    await _listenToDistanceAndSpeed();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        emit(state.copyWith(
          durationInSeconds: timer.tick.toDouble(),
        ));
      },
    );
  }

  Future<void> _listenToDistanceAndSpeed() async {
    final listenedParams$ = Rx.combineLatest2(
      _locationService.getCurrentLocation(),
      _locationService.getCurrentSpeedInMetersPerHour(),
      (Coordinates? location, double speed) => _ListenedParams(
        location: location,
        speed: speed,
      ),
    );
    await for (final listenedParams in listenedParams$) {
      List<Coordinates> updatedWaypoints = [...?state.waypoints];
      if (listenedParams.location != null) {
        updatedWaypoints.add(listenedParams.location!);
        updatedWaypoints = updatedWaypoints.toSet().toList();
      }
      emit(state.copyWith(
        distanceInMeters: updatedWaypoints.length != state.waypoints?.length &&
                updatedWaypoints.isNotEmpty
            ? _mapService.calculateDistanceInMeters(
                location1: updatedWaypoints.first,
                location2: updatedWaypoints.last,
              )
            : state.distanceInMeters,
        speedInKmPerH: listenedParams.speed * 0.001,
        waypoints: updatedWaypoints,
      ));
    }
  }
}

class _ListenedParams extends Equatable {
  final Coordinates? location;
  final double speed;

  const _ListenedParams({
    required this.location,
    required this.speed,
  });

  @override
  List<Object?> get props => [location, speed];
}
