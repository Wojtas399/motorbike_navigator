import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../cubit/date_range/date_range_cubit.dart';
import 'cubit/stats_cubit.dart';
import 'stats_content.dart';

@RoutePage()
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) =>
                getIt.get<DateRangeCubit>()..initializeWeeklyDateRange(),
          ),
          BlocProvider(
            create: (BuildContext context) {
              final DateRange? dateRange = context.read<DateRangeCubit>().state;
              if (dateRange != null) {
                return getIt.get<StatsCubit>()
                  ..onDateRangeChanged(dateRange: dateRange);
              } else {
                return getIt.get<StatsCubit>();
              }
            },
          ),
        ],
        child: const _DateRangeCubitListener(
          child: StatsContent(),
        ),
      );
}

class _DateRangeCubitListener extends StatelessWidget {
  final Widget child;

  const _DateRangeCubitListener({
    required this.child,
  });

  void _onDateRangeChanged(BuildContext context, DateRange? dateRange) {
    if (dateRange != null) {
      context.read<StatsCubit>().onDateRangeChanged(dateRange: dateRange);
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<DateRangeCubit, DateRange?>(
        listener: _onDateRangeChanged,
        child: child,
      );
}
