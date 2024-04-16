import 'package:equatable/equatable.dart';

class PlaceSuggestionDto extends Equatable {
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
      PlaceSuggestionDto(
        id: json['mapbox_id'],
        name: json['name'],
        fullAddress: json['full_address'],
      );
}
