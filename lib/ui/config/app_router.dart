import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import '../screen/screens.dart';

part 'app_router.gr.dart';

@Singleton()
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: MapRoute.page,
          initial: true,
        ),
        AutoRoute(
          page: DriveSummaryRoute.page,
        ),
        AutoRoute(
          page: RoutePreviewRoute.page,
        ),
        AutoRoute(
          page: SavedDrivesRoute.page,
        ),
        AutoRoute(
          page: StatsRoute.page,
        ),
        AutoRoute(
          page: DriveDetailsRoute.page,
        ),
      ];
}
