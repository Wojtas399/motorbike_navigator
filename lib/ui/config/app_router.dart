import 'package:auto_route/auto_route.dart';

import '../screen/screens.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
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
      ];
}
