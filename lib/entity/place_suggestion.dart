import 'package:motorbike_navigator/entity/entity.dart';

class PlaceSuggestion extends Entity {
  final String name;
  final String? address;

  const PlaceSuggestion({
    required super.id,
    required this.name,
    this.address,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        address,
      ];
}
