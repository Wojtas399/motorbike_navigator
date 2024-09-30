import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/ui/service/date_service.dart';
import 'package:motorbike_navigator/ui/service/drive_service.dart';

import '../../mock/ui_service/mock_date_service.dart';

void main() {
  final dateService = MockDateService();
  final service = DriveService(dateService);

  group(
    'getDefaultTitle, ',
    () {
      final DateTime now = DateTime(2024);

      test(
        "should return 'Poranny przejazd' if part of the day is morning",
        () {
          const String expectedTitle = 'Poranny przejazd';
          dateService.mockGetNow(expectedNow: now);
          dateService.mockGetPartOfTheDay(
            expectedPartOfTheDay: PartOfTheDay.morning,
          );

          final String title = service.getDefaultTitle();

          expect(title, expectedTitle);
        },
      );

      test(
        "should return 'Popołudniowy przejazd' if part of the day is afternoon",
        () {
          const String expectedTitle = 'Popołudniowy przejazd';
          dateService.mockGetNow(expectedNow: now);
          dateService.mockGetPartOfTheDay(
            expectedPartOfTheDay: PartOfTheDay.afternoon,
          );

          final String title = service.getDefaultTitle();

          expect(title, expectedTitle);
        },
      );

      test(
        "should return 'Wieczorny przejazd' if part of the day is evening",
        () {
          const String expectedTitle = 'Wieczorny przejazd';
          dateService.mockGetNow(expectedNow: now);
          dateService.mockGetPartOfTheDay(
            expectedPartOfTheDay: PartOfTheDay.evening,
          );

          final String title = service.getDefaultTitle();

          expect(title, expectedTitle);
        },
      );

      test(
        "should return 'Nocny przejazd' if part of the day is night",
        () {
          const String expectedTitle = 'Nocny przejazd';
          dateService.mockGetNow(expectedNow: now);
          dateService.mockGetPartOfTheDay(
            expectedPartOfTheDay: PartOfTheDay.night,
          );

          final String title = service.getDefaultTitle();

          expect(title, expectedTitle);
        },
      );
    },
  );
}
