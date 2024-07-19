import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/gap.dart';
import '../../cubit/route/route_cubit.dart';
import '../../cubit/route/route_state.dart';
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

  void _onPressed(BuildContext context) {
    context.read<RouteCubit>().reset();
    context.maybePop();
  }

  @override
  Widget build(BuildContext context) => OutlinedButton(
        onPressed: () => _onPressed(context),
        child: Text(context.str.cancel),
      );
}

class _SearchRouteButton extends StatelessWidget {
  const _SearchRouteButton();

  @override
  Widget build(BuildContext context) {
    final RouteStateStatus routeStatus = context.select(
      (RouteCubit cubit) => cubit.state.status,
    );

    return FilledButton(
      onPressed: routeStatus == RouteStateStatus.searching
          ? null
          : context.read<RouteCubit>().loadNavigation,
      style: FilledButton.styleFrom(
        disabledBackgroundColor: context.colorScheme.primary,
      ),
      child: routeStatus == RouteStateStatus.searching
          ? SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.colorScheme.primaryContainer,
              ),
            )
          : Text(context.str.mapSearchRoute),
    );
  }
}
