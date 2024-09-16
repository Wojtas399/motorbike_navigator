import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import 'component/drive_details_content.dart';
import 'cubit/drive_details_cubit.dart';

@RoutePage()
class DriveDetailsScreen extends StatelessWidget {
  final int driveId;

  const DriveDetailsScreen({
    super.key,
    required this.driveId,
  });

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<DriveDetailsCubit>()..initialize(driveId),
        child: const DriveDetailsContent(),
      );
}
