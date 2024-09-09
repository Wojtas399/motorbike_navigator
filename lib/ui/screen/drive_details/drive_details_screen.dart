import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import '../../extensions/context_extensions.dart';

@RoutePage()
class DriveDetailsScreen extends StatelessWidget {
  final int driveId;

  const DriveDetailsScreen({
    super.key,
    required this.driveId,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(context.str.driveDetailsScreenTitle),
        ),
      );
}
