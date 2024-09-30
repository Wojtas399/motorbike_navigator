import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../service/date_service.dart';

@injectable
class DateRangeCubit extends Cubit<DateRange?> {
  final DateService _dateService;

  DateRangeCubit(
    this._dateService,
  ) : super(null);

  bool get isCurrentDateRange {
    if (state == null) return false;
    final now = _dateService.getNow();
    return _dateService.isDateFromRange(
      date: now,
      firstDateOfRange: state!.firstDateOfRange,
      lastDateOfRange: state!.lastDateOfRange,
    );
  }

  void initializeWeeklyDateRange() {
    final DateTime now = _dateService.getNow();
    final DateTime firstDateOfTheWeek = _dateService.getFirstDateOfTheWeek(now);
    final DateTime lastDateOfTheWeek = _dateService.getLastDateOfTheWeek(now);
    final weeklyDateRange = WeeklyDateRange(
      firstDateOfRange: firstDateOfTheWeek,
      lastDateOfRange: lastDateOfTheWeek,
    );
    emit(weeklyDateRange);
  }

  void changeToWeeklyDateRange() {
    if (state == null) return;
    final DateTime firstDateOfTheWeek = _dateService.getFirstDateOfTheWeek(
      state!.firstDateOfRange,
    );
    final DateTime lastDateOfTheWeek = _dateService.getLastDateOfTheWeek(
      state!.firstDateOfRange,
    );
    final weeklyDateRange = WeeklyDateRange(
      firstDateOfRange: firstDateOfTheWeek,
      lastDateOfRange: lastDateOfTheWeek,
    );
    emit(weeklyDateRange);
  }

  void changeToMonthlyDateRange() {
    if (state == null) return;
    final DateTime firstDateOfTheMonth = _dateService.getFirstDateOfTheMonth(
      state!.firstDateOfRange,
    );
    final DateTime lastDateOfTheMonth = _dateService.getLastDateOfTheMonth(
      state!.firstDateOfRange,
    );
    final monthlyDateRange = MonthlyDateRange(
      firstDateOfRange: firstDateOfTheMonth,
      lastDateOfRange: lastDateOfTheMonth,
    );
    emit(monthlyDateRange);
  }

  void changeToYearlyDateRange() {
    if (state == null) return;
    final DateTime firstDateOfTheYear = _dateService.getFirstDateOfTheYear(
      state!.firstDateOfRange,
    );
    final DateTime lastDateOfTheYear = _dateService.getLastDateOfTheYear(
      state!.firstDateOfRange,
    );
    final yearlyDateRange = YearlyDateRange(
      firstDateOfRange: firstDateOfTheYear,
      lastDateOfRange: lastDateOfTheYear,
    );
    emit(yearlyDateRange);
  }

  void previousDateRange() {
    final DateRange? currentDateRange = state;
    if (currentDateRange == null) return;
    final DateRange previousDateRange = switch (currentDateRange) {
      WeeklyDateRange() => _calculatePreviousWeekRange(currentDateRange),
      MonthlyDateRange() => _calculatePreviousMonthRange(currentDateRange),
      YearlyDateRange() => _calculatePreviousYearRange(currentDateRange),
    };
    emit(previousDateRange);
  }

  void nextDateRange() {
    final DateRange? currentDateRange = state;
    if (currentDateRange == null) return;
    final DateRange nextDateRange = switch (currentDateRange) {
      WeeklyDateRange() => _calculateNextWeekRange(currentDateRange),
      MonthlyDateRange() => _calculateNextMonthRange(currentDateRange),
      YearlyDateRange() => _calculateNextYearRange(currentDateRange),
    };
    emit(nextDateRange);
  }

  WeeklyDateRange _calculatePreviousWeekRange(WeeklyDateRange dateRange) =>
      WeeklyDateRange(
        firstDateOfRange: dateRange.firstDateOfRange.subtract(
          const Duration(days: 7),
        ),
        lastDateOfRange: dateRange.lastDateOfRange.subtract(
          const Duration(days: 7),
        ),
      );

  MonthlyDateRange _calculatePreviousMonthRange(MonthlyDateRange dateRange) =>
      MonthlyDateRange(
        firstDateOfRange: DateTime(
          dateRange.firstDateOfRange.year,
          dateRange.firstDateOfRange.month - 1,
        ),
        lastDateOfRange: DateTime(
          dateRange.lastDateOfRange.year,
          dateRange.lastDateOfRange.month,
        ).subtract(const Duration(days: 1)),
      );

  YearlyDateRange _calculatePreviousYearRange(YearlyDateRange dateRange) =>
      YearlyDateRange(
        firstDateOfRange: DateTime(dateRange.firstDateOfRange.year - 1),
        lastDateOfRange: DateTime(
          dateRange.lastDateOfRange.year,
        ).subtract(const Duration(days: 1)),
      );

  WeeklyDateRange _calculateNextWeekRange(WeeklyDateRange dateRange) =>
      WeeklyDateRange(
        firstDateOfRange: dateRange.firstDateOfRange.add(
          const Duration(days: 7),
        ),
        lastDateOfRange: dateRange.lastDateOfRange.add(
          const Duration(days: 7),
        ),
      );

  MonthlyDateRange _calculateNextMonthRange(MonthlyDateRange dateRange) =>
      MonthlyDateRange(
        firstDateOfRange: DateTime(
          dateRange.firstDateOfRange.year,
          dateRange.firstDateOfRange.month + 1,
        ),
        lastDateOfRange: DateTime(
          dateRange.lastDateOfRange.year,
          dateRange.lastDateOfRange.month + 2,
        ).subtract(const Duration(days: 1)),
      );

  YearlyDateRange _calculateNextYearRange(YearlyDateRange dateRange) =>
      YearlyDateRange(
        firstDateOfRange: DateTime(dateRange.firstDateOfRange.year + 1),
        lastDateOfRange: DateTime(
          dateRange.lastDateOfRange.year + 2,
        ).subtract(const Duration(days: 1)),
      );
}

sealed class DateRange extends Equatable {
  final DateTime firstDateOfRange;
  final DateTime lastDateOfRange;

  const DateRange({
    required this.firstDateOfRange,
    required this.lastDateOfRange,
  });

  @override
  List<Object?> get props => [
        firstDateOfRange,
        lastDateOfRange,
      ];
}

class WeeklyDateRange extends DateRange {
  const WeeklyDateRange({
    required super.firstDateOfRange,
    required super.lastDateOfRange,
  });
}

class MonthlyDateRange extends DateRange {
  const MonthlyDateRange({
    required super.firstDateOfRange,
    required super.lastDateOfRange,
  });
}

class YearlyDateRange extends DateRange {
  const YearlyDateRange({
    required super.firstDateOfRange,
    required super.lastDateOfRange,
  });
}
