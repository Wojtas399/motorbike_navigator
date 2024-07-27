import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../cubit/date_range/date_range_cubit.dart';

part 'stats_state.freezed.dart';

enum StatsStateStatus { loading, completed }

@freezed
class StatsState with _$StatsState {
  const factory StatsState({
    @Default(StatsStateStatus.loading) StatsStateStatus status,
    int? numberOfDrives,
    double? mileageInKm,
    Duration? totalDuration,
    List<MileageBar>? mileageBars,
  }) = _StatsState;
}

class MileageBar extends Equatable {
  final DateTime date;
  final double value;

  const MileageBar({
    required this.date,
    required this.value,
  });

  @override
  List<Object?> get props => [date, value];
}
