import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../component/gap.dart';
import 'cubit/route_form_cubit.dart';
import 'route_form_places_selection.dart';

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
              ],
            ),
          ),
        ),
      );
}
