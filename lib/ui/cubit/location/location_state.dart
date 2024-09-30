import 'package:equatable/equatable.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationStateOn extends LocationState {
  const LocationStateOn();
}

class LocationStateOff extends LocationState {
  const LocationStateOff();
}

class LocationStateAccessDenied extends LocationState {
  const LocationStateAccessDenied();
}
