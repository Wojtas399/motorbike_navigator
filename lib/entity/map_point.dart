import 'package:equatable/equatable.dart';

abstract class MapPoint extends Equatable {
  const MapPoint();

  @override
  List<Object?> get props => [];
}

class UserLocationPoint extends MapPoint {
  const UserLocationPoint();
}

class SelectedPlacePoint extends MapPoint {
  final String id;
  final String name;

  const SelectedPlacePoint({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
