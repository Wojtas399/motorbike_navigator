import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/text.dart';
import '../../../extensions/context_extensions.dart';
import '../../../extensions/datetime_extensions.dart';
import '../cubit/drive_details_cubit.dart';

class DriveDetailsHeader extends StatelessWidget {
  const DriveDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final DateTime? startDateTime = context.select(
      (DriveDetailsCubit cubit) => cubit.state.drive?.startDateTime,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TitleLarge(
            '${startDateTime?.toUIDate()},',
            fontWeight: FontWeight.bold,
          ),
          TitleMedium(
            ' godz. ${startDateTime?.toUITime()}',
            color: context.colorScheme.outline,
          ),
        ],
      ),
    );
  }
}
