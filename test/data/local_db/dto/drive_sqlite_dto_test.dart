import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/local_db/dto/drive_sqlite_dto.dart';
import 'package:motorbike_navigator/data/mapper/datetime_mapper.dart';

import '../../../mock/data/mapper/mock_datetime_mapper.dart';

void main() {
  final dateTimeMapper = MockDatetimeMapper();
  const int id = 1;
  const String title = 'drive title';
  final DateTime startDateTime = DateTime(2024, 7, 29, 2, 30);
  const String startDateStr = '2024-07-29';
  const String startTimeStr = '02:30';
  const double distance = 12.2;
  const Duration duration = Duration(hours: 1, minutes: 22);

  setUpAll(() {
    GetIt.I.registerFactory<DateTimeMapper>(() => dateTimeMapper);
  });

  tearDown(() {
    reset(dateTimeMapper);
  });

  test(
    'fromJson, '
    'should map json object to DriveSqliteDto object',
    () {
      final Map<String, Object?> json = {
        'id': id,
        'title': title,
        'start_date': startDateStr,
        'start_time': startTimeStr,
        'distance': distance,
        'duration': duration.inSeconds,
      };
      final DriveSqliteDto expectedDto = DriveSqliteDto(
        id: id,
        title: title,
        startDateTime: startDateTime,
        distanceInKm: distance,
        duration: duration,
      );
      dateTimeMapper.mockMapFromDateAndTimeStrings(
        expectedDateTime: startDateTime,
      );

      final DriveSqliteDto dto = DriveSqliteDto.fromJson(json);

      expect(dto, expectedDto);
    },
  );

  test(
    'toJson, '
    'should map DriveSqliteDto object to json object without id key',
    () {
      final DriveSqliteDto dto = DriveSqliteDto(
        id: id,
        title: title,
        startDateTime: startDateTime,
        distanceInKm: distance,
        duration: duration,
      );
      final Map<String, Object?> expectedJson = {
        'title': title,
        'start_date': startDateStr,
        'start_time': startTimeStr,
        'distance': distance,
        'duration': duration.inSeconds,
      };
      dateTimeMapper.mockMapToDateString(expectedDateStr: startDateStr);
      dateTimeMapper.mockMapToTimeString(expectedTimeStr: startTimeStr);

      final Map<String, Object?> json = dto.toJson();

      expect(json, expectedJson);
    },
  );
}
