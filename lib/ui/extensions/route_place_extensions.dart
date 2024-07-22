import 'package:flutter/material.dart';

import '../cubit/route/route_state.dart';
import 'context_extensions.dart';

extension RoutePlaceExtensions on RoutePlace {
  String toUIName(BuildContext context) {
    final routePlace = this;
    if (routePlace is UserLocationRoutePlace) {
      return context.str.yourLocalization;
    } else if (routePlace is SelectedRoutePlace) {
      return routePlace.name;
    }
    return context.str.unknown;
  }
}
