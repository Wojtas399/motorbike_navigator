import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../entity/drive.dart';

part 'drive_details_state.freezed.dart';

enum DriveDetailsStateStatus { loading, completed }

@freezed
class DriveDetailsState with _$DriveDetailsState {
  const factory DriveDetailsState({
    @Default(DriveDetailsStateStatus.loading) DriveDetailsStateStatus status,
    Drive? drive,
    List<DriveDetailsDistanceAreaChartData>? speedAreaChartData,
    List<DriveDetailsDistanceAreaChartData>? elevationAreaChartData,
  }) = _DriveDetailsState;
}

class DriveDetailsDistanceAreaChartData extends Equatable {
  final double distance;
  final double value;

  const DriveDetailsDistanceAreaChartData({
    required this.distance,
    required this.value,
  });

  @override
  List<Object?> get props => [distance, value];
}
