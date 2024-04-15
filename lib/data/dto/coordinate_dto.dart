import 'package:equatable/equatable.dart';
import 'package:mapbox_search/models/location.dart';

class CoordinateDto extends Equatable {
  final double latitude;
  final double longitude;

  const CoordinateDto(this.latitude, this.longitude);

  @override
  List<Object?> get props => [latitude, longitude];

  factory CoordinateDto.fromMapboxLocation(Location location) => CoordinateDto(
        location.lat,
        location.long,
      );
}
