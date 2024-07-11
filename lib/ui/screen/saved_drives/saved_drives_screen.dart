import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../../entity/drive.dart';
import '../../extensions/context_extensions.dart';
import 'cubit/saved_drives_cubit.dart';
import 'cubit/saved_drives_state.dart';
import 'saved_drives_drive_item.dart';

@RoutePage()
class SavedDrivesScreen extends StatelessWidget {
  const SavedDrivesScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<SavedDrivesCubit>()..initialize(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(context.str.savedDrivesScreenTitle),
          ),
          body: const SafeArea(
            child: _Body(),
          ),
        ),
      );
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final SavedDrivesStateStatus cubitStatus = context.select(
      (SavedDrivesCubit cubit) => cubit.state.status,
    );

    return switch (cubitStatus) {
      SavedDrivesStateStatus.loading => const CircularProgressIndicator(),
      SavedDrivesStateStatus.completed => const _ListOfDrives(),
    };
  }
}

class _ListOfDrives extends StatelessWidget {
  const _ListOfDrives();

  @override
  Widget build(BuildContext context) {
    final List<Drive> drives = context.select(
      (SavedDrivesCubit cubit) => cubit.state.drives,
    );

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 24),
      itemCount: drives.length,
      itemBuilder: (_, int itemIndex) => SavedDrivesDriveItem(
        drive: drives[itemIndex],
      ),
    );
  }
}
