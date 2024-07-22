import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../entity/navigation.dart';
import '../../../entity/map_point.dart';

part 'route_state.freezed.dart';

enum RouteStateStatus {
  initial,
  infill,
  formNotCompleted,
  pointsMustBeDifferent,
  searching,
  routeFound,
  routeNotFound,
}

@freezed
class RouteState with _$RouteState {
  const factory RouteState({
    @Default(RouteStateStatus.initial) RouteStateStatus status,
    @Default(UserLocationPoint()) MapPoint? startPoint,
    MapPoint? endPoint,
    Route? route,
  }) = _RouteState;
}
