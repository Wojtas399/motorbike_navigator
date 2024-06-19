import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'route_dto.dart';

part 'navigation_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class NavigationDto extends Equatable {
  @JsonKey(name: 'uuid')
  final String id;
  final List<RouteDto> routes;

  const NavigationDto({
    required this.id,
    required this.routes,
  });

  @override
  List<Object?> get props => [id, routes];

  factory NavigationDto.fromJson(Map<String, dynamic> json) =>
      _$NavigationDtoFromJson(json);
}
