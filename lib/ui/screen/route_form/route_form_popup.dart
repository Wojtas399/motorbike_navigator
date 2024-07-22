import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/gap.dart';
import '../../cubit/route/route_cubit.dart';
import '../../extensions/context_extensions.dart';
import 'route_form_action_buttons.dart';
import 'route_form_text_fields.dart';

class RouteFormPopup extends StatelessWidget {
  const RouteFormPopup({super.key});

  @override
  Widget build(BuildContext context) => const _BodyContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GapHorizontal8(),
                _RouteIcons(),
                GapHorizontal16(),
                Expanded(
                  child: RouteFormTextFields(),
                ),
                GapHorizontal8(),
                _SwapPointsButton(),
              ],
            ),
            GapVertical16(),
            RouteFormActionButtons(),
          ],
        ),
      );
}

class _BodyContainer extends StatelessWidget {
  final Widget child;

  const _BodyContainer({
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 64),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: child,
      );
}

class _RouteIcons extends StatelessWidget {
  const _RouteIcons();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Icon(
            Icons.my_location,
            color: context.colorScheme.primary,
          ),
          const GapVertical8(),
          const Icon(Icons.more_vert),
          const GapVertical8(),
          const Icon(
            Icons.location_on_outlined,
            color: Colors.red,
          ),
        ],
      );
}

class _SwapPointsButton extends StatelessWidget {
  const _SwapPointsButton();

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: context.read<RouteCubit>().swapPoints,
        icon: const Icon(
          Icons.swap_vert,
          size: 32,
        ),
      );
}
