import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';

import '../screen/screens.dart';

part 'app_router.gr.dart';

@injectable
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
          children: [
            AutoRoute(
              page: DriveSummaryRoute.page,
            ),
            AutoRoute(
              page: RoutePreviewRoute.page,
            ),
          ],
        ),
      ];
}
