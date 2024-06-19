import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../component/gap.dart';
import 'cubit/route_form_cubit.dart';
import 'route_form_places_selection.dart';

typedef RouteFormResult = ({String startPlaceId, String destinationId});

class RouteFormScreen extends StatelessWidget {
  const RouteFormScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<RouteFormCubit>(),
        child: const Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                GapVertical24(),
                RouteFormPlacesSelection(),
                GapVertical24(),
                _SubmitButton(),
              ],
            ),
          ),
        ),
      );
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  void _onPressed(BuildContext context) {
    final cubitState = context.read<RouteFormCubit>().state;
    Navigator.pop(context, (
      startPlaceId: cubitState.startPlace!.id,
      destinationId: cubitState.destination!.id,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = context.select(
      (RouteFormCubit cubit) => cubit.state.isCompleted,
    );

    return FilledButton(
      onPressed: isActive ? () => _onPressed(context) : null,
      child: const Text('Wyznacz trasę'),
    );
  }
}
