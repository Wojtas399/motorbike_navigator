import 'package:equatable/equatable.dart';

class CoordinatesDto extends Equatable {
  final double lat;
  final double long;

  const CoordinatesDto({
    required this.lat,
    required this.long,
  });

  @override
  List<Object?> get props => [lat, long];

  factory CoordinatesDto.fromFirebaseArray(
    List<double> coordinatesArray,
  ) =>
      CoordinatesDto(
        lat: coordinatesArray.first,
        long: coordinatesArray.last,
      );

  factory CoordinatesDto.fromMapboxArray(
    List<double> coordinatesArray,
  ) =>
      CoordinatesDto(
        lat: coordinatesArray.last,
        long: coordinatesArray.first,
      );

  List<double> toFirebaseArray() => [lat, long];
}
