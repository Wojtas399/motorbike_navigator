import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/entity.dart';

class Place extends Entity {
  final String name;
  final Coordinates coordinates;

  const Place({
    required super.id,
    required this.name,
    required this.coordinates,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        coordinates,
      ];
}
