import 'package:equatable/equatable.dart';

class CoordinatesDto extends Equatable {
  final double latitude;
  final double longitude;

  const CoordinatesDto(this.latitude, this.longitude);

  @override
  List<Object?> get props => [latitude, longitude];

  factory CoordinatesDto.fromJson(Map<String, dynamic> json) => CoordinatesDto(
        json['coordinates'][0],
        json['coordinates'][1],
      );
}
