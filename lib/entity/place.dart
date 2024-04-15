import 'package:motorbike_navigator/entity/coordinate.dart';
import 'package:motorbike_navigator/entity/entity.dart';

class Place extends Entity {
  final String name;
  final Coordinate coordinate;

  const Place({
    required super.id,
    required this.name,
    required this.coordinate,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        coordinate,
      ];
}
