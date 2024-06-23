import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/gap.dart';
import '../../component/text.dart';
import '../../extensions/context_extensions.dart';
import 'cubit/map_cubit.dart';

class MapRouteDetails extends StatefulWidget {
  const MapRouteDetails({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MapRouteDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _positionAnimation = Tween<double>(begin: 400, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInCubic,
      ),
    );
    _animationController.forward();
    super.initState();
  }

  void _onClose() {
    _animationController.reverse().whenComplete(
          context.read<MapCubit>().resetSelectedPlace,
        );
  }

  @override
  Widget build(BuildContext context) {
    // final Place? selectedPlace = context.select(
    //   (MapCubit cubit) => cubit.state.selectedPlace,
    // );

    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _positionAnimation.value),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                offset: const Offset(0, -2),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Dystans: ',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: context.colorScheme.outline,
                        ),
                  ),
                  const GapHorizontal4(),
                  const TitleMedium('2.4 km'),
                ],
              ),
              const GapVertical8(),
              Row(
                children: [
                  Text(
                    'Szacowany czas: ',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: context.colorScheme.outline,
                        ),
                  ),
                  const GapHorizontal4(),
                  const TitleMedium('3 min'),
                ],
              ),
              const GapVertical24(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 250,
                    child: FilledButton.icon(
                      onPressed: _onClose,
                      icon: const Icon(Icons.navigation),
                      label: const Text('Rozpocznij'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
