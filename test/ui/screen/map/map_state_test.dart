import 'package:flutter_test/flutter_test.dart';
import 'package:motorbike_navigator/ui/screen/map/cubit/map_state.dart';

void main() {
  test(
    'default state',
    () {
      const MapState expectedState = MapState(
        status: MapStatus.loading,
        centerLocation: null,
        userLocation: null,
      );

      const state = MapState();

      expect(state, expectedState);
    },
  );
}
