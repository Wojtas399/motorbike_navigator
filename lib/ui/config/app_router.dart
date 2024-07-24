import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import '../screen/screens.dart';

part 'app_router.gr.dart';

@Singleton()
@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SignInRoute.page,
          initial: true,
        ),
        AutoRoute(
          page: MapRoute.page,
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
      ];
}
