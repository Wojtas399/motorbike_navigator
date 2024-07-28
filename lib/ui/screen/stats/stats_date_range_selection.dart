import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/gap.dart';
import '../../component/text.dart';
import '../../cubit/date_range/date_range_cubit.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/datetime_extensions.dart';

class StatsDateRangeSelection extends StatelessWidget {
  const StatsDateRangeSelection({super.key});

  @override
  Widget build(BuildContext context) => const Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PreviousDateRangeButton(),
                _DateRange(),
                _NextDateRangeButton(),
              ],
            ),
          ),
          GapVertical16(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: _DateRangeTypeSelection(),
          ),
        ],
      );
}

class _DateRange extends StatelessWidget {
  const _DateRange();

  String _formatDateRange(
    DateRange dateRange,
    bool isCurrentDateRange,
    BuildContext context,
  ) =>
      switch (dateRange) {
        WeeklyDateRange() =>
          _createWeeklyDateRangeLabel(dateRange, isCurrentDateRange, context),
        MonthlyDateRange() =>
          _createMonthlyDateRangeLabel(dateRange, isCurrentDateRange, context),
        YearlyDateRange() =>
          _createYearlyDateRangeLabel(dateRange, isCurrentDateRange, context),
      };

  String _createWeeklyDateRangeLabel(
    WeeklyDateRange dateRange,
    bool isCurrentWeek,
    BuildContext context,
  ) {
    if (isCurrentWeek) return context.str.statsCurrentWeek;
    final String firstDateOfTheWeekStr = dateRange.firstDateOfRange.toUIDate();
    final String lastDateOfTheWeekStr = dateRange.lastDateOfRange.toUIDate();
    return '$firstDateOfTheWeekStr - $lastDateOfTheWeekStr';
  }

  String _createMonthlyDateRangeLabel(
    MonthlyDateRange dateRange,
    bool isCurrentMonth,
    BuildContext context,
  ) =>
      isCurrentMonth
          ? context.str.statsCurrentMonth
          : dateRange.firstDateOfRange.toNamedMonthWithYear(context);

  String _createYearlyDateRangeLabel(
    YearlyDateRange dateRange,
    bool isCurrentYear,
    BuildContext context,
  ) =>
      isCurrentYear
          ? context.str.statsCurrentYear
          : '${dateRange.firstDateOfRange.year}';

  @override
  Widget build(BuildContext context) {
    final DateRange? dateRange = context.select(
      (DateRangeCubit cubit) => cubit.state,
    );
    final bool isCurrentDateRange = context.select(
      (DateRangeCubit cubit) => cubit.isCurrentDateRange,
    );

    return TitleMedium(
      dateRange != null
          ? _formatDateRange(dateRange, isCurrentDateRange, context)
          : '',
    );
  }
}

class _PreviousDateRangeButton extends StatelessWidget {
  const _PreviousDateRangeButton();

  @override
  Widget build(BuildContext context) => IconButton.outlined(
        onPressed: context.read<DateRangeCubit>().previousDateRange,
        icon: const Icon(Icons.arrow_back),
      );
}

class _NextDateRangeButton extends StatelessWidget {
  const _NextDateRangeButton();

  @override
  Widget build(BuildContext context) => IconButton.outlined(
        onPressed: context.read<DateRangeCubit>().nextDateRange,
        icon: const Icon(Icons.arrow_forward),
      );
}

class _DateRangeTypeSelection extends StatelessWidget {
  const _DateRangeTypeSelection();

  @override
  Widget build(BuildContext context) {
    final DateRange? currentDateRange = context.select(
      (DateRangeCubit cubit) => cubit.state,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _DateRangeTypeButton(
            isSelected: currentDateRange is WeeklyDateRange,
            onPressed: context.read<DateRangeCubit>().changeToWeeklyDateRange,
            label: context.str.statsWeek,
          ),
        ),
        const GapHorizontal16(),
        Expanded(
          child: _DateRangeTypeButton(
            isSelected: currentDateRange is MonthlyDateRange,
            onPressed: context.read<DateRangeCubit>().changeToMonthlyDateRange,
            label: context.str.statsMonth,
          ),
        ),
        const GapHorizontal16(),
        Expanded(
          child: _DateRangeTypeButton(
            isSelected: currentDateRange is YearlyDateRange,
            onPressed: context.read<DateRangeCubit>().changeToYearlyDateRange,
            label: context.str.statsYear,
          ),
        ),
      ],
    );
  }
}

class _DateRangeTypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _DateRangeTypeButton({
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => isSelected
      ? FilledButton(
          onPressed: onPressed,
          child: Text(label),
        )
      : OutlinedButton(
          onPressed: onPressed,
          child: Text(label),
        );
}
