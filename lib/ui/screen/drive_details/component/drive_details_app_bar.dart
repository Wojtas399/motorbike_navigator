import 'package:flutter/material.dart';

import '../../../component/gap.dart';
import '../../../component/text.dart';
import '../../../extensions/context_extensions.dart';

class DriveDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const DriveDetailsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        centerTitle: true,
        title: Text(context.str.driveDetailsScreenTitle),
        actions: const [
          _PopupMenu(),
        ],
      );
}

class _PopupMenu extends StatelessWidget {
  const _PopupMenu();

  @override
  Widget build(BuildContext context) => PopupMenuButton(
        itemBuilder: (_) => [
          _PopupMenuItem(
            icon: Icons.edit_outlined,
            label: context.str.driveDetailsEditTitle,
          ),
          _PopupMenuItem(
            icon: Icons.delete_outline,
            label: context.str.driveDetailsDeleteDrive,
            color: context.colorScheme.error,
          ),
        ],
      );
}

class _PopupMenuItem extends PopupMenuItem {
  _PopupMenuItem({
    required IconData icon,
    required String label,
    Color? color,
  }) : super(
          child: Row(
            children: [
              Icon(
                icon,
                color: color,
              ),
              const GapHorizontal8(),
              BodyMedium(
                label,
                color: color,
              ),
            ],
          ),
        );
}
