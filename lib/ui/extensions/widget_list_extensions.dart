import 'package:flutter/widgets.dart';

extension WidgetListExtensions on List<Widget> {
  List<Widget> separate(Widget separator) {
    final List<Widget> separatedList = [];
    for (int i = 0; i < length; i++) {
      separatedList.add(this[i]);
      if (i < length - 1) separatedList.add(separator);
    }
    return separatedList;
  }
}
