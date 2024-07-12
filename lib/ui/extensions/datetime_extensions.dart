import '../../dependency_injection.dart';
import '../service/number_service.dart';

extension DatetimeExtensions on DateTime {
  String toUIDate() {
    final numberService = getIt.get<NumberService>();
    final String dayStr = numberService.twoDigits(day);
    final String monthStr = numberService.twoDigits(month);
    return '$dayStr.$monthStr.$year';
  }

  String toUITime() {
    final numberService = getIt.get<NumberService>();
    final String minuteStr = numberService.twoDigits(minute);
    return '$hour:$minuteStr';
  }
}
