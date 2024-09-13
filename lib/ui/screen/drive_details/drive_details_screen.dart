import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../component/gap.dart';
import '../../extensions/context_extensions.dart';
import 'component/drive_details_basic_info.dart';
import 'component/drive_details_charts.dart';
import 'component/drive_details_header.dart';
import 'component/drive_details_route_preview.dart';
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
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(context.str.driveDetailsScreenTitle),
          ),
          body: const _Content(),
        ),
      );
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) => const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Column(
            children: [
              DriveDetailsHeader(),
              GapVertical24(),
              DriveDetailsRoutePreview(),
              GapVertical24(),
              DriveDetailsBasicInfo(),
              GapVertical24(),
              DriveDetailsCharts(),
            ],
          ),
        ),
      );
}
