import 'package:flutter/cupertino.dart';

import '../../dependency_injection.dart';
import '../service/number_service.dart';
import 'context_extensions.dart';

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

  String toDay() {
    final numberService = getIt.get<NumberService>();
    final dayStr = numberService.twoDigits(day);
    return dayStr;
  }

  String toNamedMonthWithYear(BuildContext context) {
    final List<String> monthName = [
      context.str.january,
      context.str.february,
      context.str.march,
      context.str.april,
      context.str.may,
      context.str.june,
      context.str.july,
      context.str.august,
      context.str.september,
      context.str.october,
      context.str.november,
      context.str.december,
    ];
    return '${monthName[month - 1]} $year';
  }

  String toDayAbbr(BuildContext context) {
    final List<String> dayAbbrs = [
      context.str.mondayAbbr,
      context.str.tuesdayAbbr,
      context.str.wednesdayAbbr,
      context.str.thursdayAbbr,
      context.str.fridayAbbr,
      context.str.saturdayAbbr,
      context.str.sundayAbbr,
    ];
    return dayAbbrs[weekday - 1];
  }

  String toMonthAbbr(BuildContext context) {
    final List<String> monthAbbrs = [
      context.str.januaryAbbr,
      context.str.februaryAbbr,
      context.str.marchAbbr,
      context.str.aprilAbbr,
      context.str.mayAbbr,
      context.str.juneAbbr,
      context.str.julyAbbr,
      context.str.augustAbbr,
      context.str.septemberAbbr,
      context.str.octoberAbbr,
      context.str.novemberAbbr,
      context.str.decemberAbbr,
    ];
    return monthAbbrs[month - 1];
  }
}
