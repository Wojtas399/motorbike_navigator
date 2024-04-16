import 'package:equatable/equatable.dart';
import 'package:mapbox_search/models/location.dart';

class CoordinatesDto extends Equatable {
  final double latitude;
  final double longitude;

  const CoordinatesDto(this.latitude, this.longitude);

  @override
  List<Object?> get props => [latitude, longitude];

  factory CoordinatesDto.fromMapboxLocation(Location location) =>
      CoordinatesDto(
        location.lat,
        location.long,
      );
}
