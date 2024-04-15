import 'package:motorbike_navigator/entity/entity.dart';

class PlaceSuggestion extends Entity {
  final String name;
  final String? fullAddress;

  const PlaceSuggestion({
    required super.id,
    required this.name,
    this.fullAddress,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        fullAddress,
      ];
}
