import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'route_dto.dart';

part 'navigation_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class NavigationDto extends Equatable {
  final List<RouteDto> routes;

  const NavigationDto({
    required this.routes,
  });

  @override
  List<Object?> get props => [routes];

  factory NavigationDto.fromJson(Map<String, dynamic> json) =>
      _$NavigationDtoFromJson(json);
}
