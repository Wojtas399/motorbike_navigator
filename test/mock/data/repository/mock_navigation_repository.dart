import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:motorbike_navigator/data/repository/navigation/navigation_repository.dart';
import 'package:motorbike_navigator/entity/coordinates.dart';
import 'package:motorbike_navigator/entity/navigation.dart';

class MockNavigationRepository extends Mock implements NavigationRepository {
  MockNavigationRepository() {
    registerFallbackValue(const Coordinates(50.1, 18.1));
  }

  void mockLoadNavigationByStartAndEndLocations({
    Navigation? navigation,
  }) {
    when(
      () => loadNavigationByStartAndEndLocations(
        startLocation: any(named: 'startLocation'),
        endLocation: any(named: 'endLocation'),
      ),
    ).thenAnswer((_) => Future.value(navigation));
  }
}
