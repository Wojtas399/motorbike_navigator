import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place_suggestion_dto.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createToJson: false)
class PlaceSuggestionDto extends Equatable {
  @JsonKey(name: 'mapbox_id')
  final String id;
  final String name;
  final String? fullAddress;

  const PlaceSuggestionDto({
    required this.id,
    required this.name,
    this.fullAddress,
  });

  @override
  List<Object?> get props => [id, name, fullAddress];

  factory PlaceSuggestionDto.fromJson(Map<String, dynamic> json) =>
      _$PlaceSuggestionDtoFromJson(json);
}
