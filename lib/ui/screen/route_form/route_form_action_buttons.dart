import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/gap.dart';
import '../../cubit/route/route_cubit.dart';
import '../../extensions/context_extensions.dart';

class RouteFormActionButtons extends StatelessWidget {
  const RouteFormActionButtons({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: _CancelButton(),
            ),
            GapHorizontal16(),
            Expanded(
              child: _SearchRouteButton(),
            ),
          ],
        ),
      );
}

class _CancelButton extends StatelessWidget {
  const _CancelButton();

  @override
  Widget build(BuildContext context) => OutlinedButton(
        onPressed: context.maybePop,
        child: Text(context.str.cancel),
      );
}

class _SearchRouteButton extends StatelessWidget {
  const _SearchRouteButton();

  Future<void> _onPressed(BuildContext context) async {
    await context.read<RouteCubit>().loadNavigation();
    if (context.mounted) context.maybePop();
  }

  @override
  Widget build(BuildContext context) => FilledButton(
        onPressed: () => _onPressed(context),
        child: Text(context.str.mapSearchRoute),
      );
}
