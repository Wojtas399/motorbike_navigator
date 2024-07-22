import 'package:flutter/material.dart';

import '../../entity/map_point.dart';
import 'context_extensions.dart';

extension MapPointExtensions on MapPoint {
  String toUIName(BuildContext context) {
    final mapPoint = this;
    if (mapPoint is UserLocationPoint) {
      return context.str.yourLocalization;
    } else if (mapPoint is SelectedPlacePoint) {
      return mapPoint.name;
    }
    return context.str.unknown;
  }
}
