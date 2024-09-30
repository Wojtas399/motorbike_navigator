import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'stats_state.freezed.dart';

enum StatsStateStatus { loading, completed }

@freezed
class StatsState with _$StatsState {
  const factory StatsState({
    @Default(StatsStateStatus.loading) StatsStateStatus status,
    int? numberOfDrives,
    double? mileageInKm,
    Duration? totalDuration,
    List<MileageChartData>? mileageChartData,
  }) = _StatsState;
}

class MileageChartData extends Equatable {
  final DateTime date;
  final double value;

  const MileageChartData({
    required this.date,
    required this.value,
  });

  @override
  List<Object?> get props => [date, value];
}
