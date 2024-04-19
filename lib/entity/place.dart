import 'coordinates.dart';
import 'entity.dart';

class Place extends Entity {
  final String name;
  final String fullAddress;
  final Coordinates coordinates;

  const Place({
    required super.id,
    required this.name,
    required this.fullAddress,
    required this.coordinates,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        fullAddress,
        coordinates,
      ];
}
