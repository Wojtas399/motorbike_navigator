import 'package:motorbike_navigator/data/local_db/dto/drive_sqlite_dto.dart';
import 'package:motorbike_navigator/entity/drive.dart';

class DriveCreator {
  final int id;
  final String title;
  late final DateTime startDateTime;
  final double distanceInKm;
  final Duration duration;
  final List<DrivePosition> positions;

  DriveCreator({
    this.id = 0,
    this.title = '',
    DateTime? startDateTime,
    this.distanceInKm = 0.0,
    this.duration = const Duration(seconds: 0),
    this.positions = const [],
  }) {
    this.startDateTime = startDateTime ?? DateTime(2024);
  }

  Drive createEntity() => Drive(
        id: id,
        title: title,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
        positions: positions,
      );

  DriveSqliteDto createSqliteDto() => DriveSqliteDto(
        id: id,
        title: title,
        startDateTime: startDateTime,
        distanceInKm: distanceInKm,
        duration: duration,
      );

  Map<String, dynamic> createJson() {
    final String startDateStr =
        '${startDateTime.year}-${_twoDigits(startDateTime.month)}-${_twoDigits(startDateTime.day)}';
    final String startTimeStr =
        '${_twoDigits(startDateTime.hour)}-${_twoDigits(startDateTime.minute)}';
    return {
      'id': id,
      'title': title,
      'start_date': startDateStr,
      'start_time': startTimeStr,
      'distance': distanceInKm,
      'duration': duration.inSeconds,
    };
  }

  String _twoDigits(int number) => number.toString().padLeft(2, '0');
}
