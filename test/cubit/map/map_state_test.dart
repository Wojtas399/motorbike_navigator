import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/ui/map/cubit/map_state.dart';

void main() {
  test(
    'default state',
    () {
      const MapState expectedState = MapState(
        status: MapStatus.loading,
        searchQuery: '',
        centerLocation: Coordinates(
          52.23178179122954,
          21.006002101026827,
        ),
        userLocation: null,
        selectedPlace: null,
      );

      const state = MapState();

      expect(state, expectedState);
    },
  );
}
