import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../entity/navigation.dart';

part 'route_state.freezed.dart';

enum RouteStateStatus {
  initial,
  infill,
  formNotCompleted,
  searching,
  routeFound,
  routeNotFound,
}

@freezed
class RouteState with _$RouteState {
  const factory RouteState({
    @Default(RouteStateStatus.initial) RouteStateStatus status,
    @Default(UserLocationRoutePlace()) RoutePlace? startPlace,
    RoutePlace? destination,
    Route? route,
  }) = _RouteState;
}

abstract class RoutePlace extends Equatable {
  const RoutePlace();

  @override
  List<Object?> get props => [];
}

class UserLocationRoutePlace extends RoutePlace {
  const UserLocationRoutePlace();
}

class SelectedRoutePlace extends RoutePlace {
  final String id;
  final String name;

  const SelectedRoutePlace({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}
