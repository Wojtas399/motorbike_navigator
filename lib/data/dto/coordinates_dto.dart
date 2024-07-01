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

  factory CoordinatesDto.fromJson(List coordinates) => CoordinatesDto(
        lat: coordinates.last,
        long: coordinates.first,
      );

  List<double> toJson() => [long, lat];
}
