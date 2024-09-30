import 'package:injectable/injectable.dart';

import '../../ui/service/number_service.dart';

@injectable
class DateTimeMapper {
  final NumberService _numberService;

  const DateTimeMapper(this._numberService);

  DateTime mapFromDateAndTimeStrings(String date, String time) {
    final List<String> dateParts = date.split('-');
    final List<String> timeParts = time.split(':');
    final int year = int.parse(dateParts.first);
    final int month = int.parse(dateParts[1]);
    final int day = int.parse(dateParts.last);
    final int hour = int.parse(timeParts.first);
    final int minute = int.parse(timeParts.last);
    return DateTime(year, month, day, hour, minute);
  }

  String mapToDateString(DateTime dateTime) {
    final String monthStr = _numberService.twoDigits(dateTime.month);
    final String dayStr = _numberService.twoDigits(dateTime.day);
    return '${dateTime.year}-$monthStr-$dayStr';
  }

  String mapToTimeString(DateTime dateTime) {
    final String hourStr = _numberService.twoDigits(dateTime.hour);
    final String minuteStr = _numberService.twoDigits(dateTime.minute);
    return '$hourStr:$minuteStr';
  }
}
