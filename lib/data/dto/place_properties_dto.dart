import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place_properties_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class PlacePropertiesDto extends Equatable {
  final String mapboxId;
  final String name;

  const PlacePropertiesDto({
    required this.mapboxId,
    required this.name,
  });

  @override
  List<Object?> get props => [mapboxId, name];

  factory PlacePropertiesDto.fromJson(Map<String, dynamic> json) =>
      _$PlacePropertiesDtoFromJson(json);
}
