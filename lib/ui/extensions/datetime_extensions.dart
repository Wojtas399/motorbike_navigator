import '../../dependency_injection.dart';
import '../service/number_service.dart';

extension DatetimeExtensions on DateTime {
  String toUIDateWithTimeFormat() {
    final numberService = getIt.get<NumberService>();
    final String dayStr = numberService.twoDigits(day);
    final String monthStr = numberService.twoDigits(month);
    final String minuteStr = numberService.twoDigits(minute);
    return '$dayStr.$monthStr.$year, $hour:$minuteStr';
  }
}
