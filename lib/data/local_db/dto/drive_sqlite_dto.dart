import 'package:equatable/equatable.dart';

import '../../../dependency_injection.dart';
import '../../mapper/datetime_mapper.dart';

class DriveSqliteDto extends Equatable {
  final int id;
  final String title;
  final DateTime startDateTime;
  final double distanceInKm;
  final Duration duration;

  const DriveSqliteDto({
    this.id = 0,
    required this.title,
    required this.startDateTime,
    required this.distanceInKm,
    required this.duration,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        startDateTime,
        distanceInKm,
        duration,
      ];

  factory DriveSqliteDto.fromJson(Map<String, Object?> json) => DriveSqliteDto(
        title: json['title'] as String,
        startDateTime: getIt.get<DateTimeMapper>().mapFromDateAndTimeStrings(
              json['start_date'] as String,
              json['start_time'] as String,
            ),
        id: json['id'] as int? ?? 0,
        distanceInKm: (json['distance'] as num).toDouble(),
        duration: Duration(seconds: json['duration'] as int),
      );

  Map<String, dynamic> toJson() {
    final dateTimeMapper = getIt.get<DateTimeMapper>();
    return {
      'title': title,
      'start_date': dateTimeMapper.mapToDateString(startDateTime),
      'start_time': dateTimeMapper.mapToTimeString(startDateTime),
      'distance': distanceInKm,
      'duration': duration.inSeconds,
    };
  }
}
