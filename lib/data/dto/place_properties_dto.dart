import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place_properties_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class PlacePropertiesDto extends Equatable {
  @JsonKey(name: 'mapbox_id')
  final String id;
  final String name;
  final String fullAddress;

  const PlacePropertiesDto({
    required this.id,
    required this.name,
    required this.fullAddress,
  });

  @override
  List<Object?> get props => [id, name, fullAddress];

  factory PlacePropertiesDto.fromJson(Map<String, dynamic> json) =>
      _$PlacePropertiesDtoFromJson(json);
}
