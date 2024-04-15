import 'package:equatable/equatable.dart';

class Coordinate extends Equatable {
  final double latitude;
  final double longitude;

  const Coordinate(this.latitude, this.longitude);

  @override
  List<Object?> get props => [latitude, longitude];
}
