import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/gap.dart';
import '../../../component/text.dart';
import '../../../extensions/context_extensions.dart';
import '../../../extensions/datetime_extensions.dart';
import '../cubit/drive_details_cubit.dart';

class DriveDetailsHeader extends StatelessWidget {
  const DriveDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final String? title = context.select(
      (DriveDetailsCubit cubit) => cubit.state.drive?.title,
    );
    final DateTime? startDateTime = context.select(
      (DriveDetailsCubit cubit) => cubit.state.drive?.startDateTime,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleLarge(
            '$title',
            fontWeight: FontWeight.bold,
          ),
          const GapHorizontal8(),
          TitleMedium(
            '${startDateTime?.toUIDate()}, ${context.str.hourAbbr} ${startDateTime?.toUITime()}',
            fontWeight: FontWeight.w300,
          ),
        ],
      ),
    );
  }
}
