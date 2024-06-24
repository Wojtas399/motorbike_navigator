import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../entity/place.dart';
import '../../component/gap.dart';
import '../../component/text.dart';
import '../../cubit/map/map_cubit.dart';
import '../../extensions/context_extensions.dart';

class MapSelectedPlaceDetails extends StatefulWidget {
  const MapSelectedPlaceDetails({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MapSelectedPlaceDetails>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _positionAnimation = Tween<double>(begin: 0, end: 400).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInCubic,
      ),
    );
    super.initState();
  }

  void _onClose() {
    _animationController.forward().whenComplete(
          context.read<MapCubit>().resetSelectedPlace,
        );
  }

  @override
  Widget build(BuildContext context) {
    final Place? selectedPlace = context.select(
      (MapCubit cubit) => cubit.state.selectedPlace,
    );

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
              TitleMedium(selectedPlace!.name),
              const GapVertical8(),
              BodyMedium(selectedPlace.fullAddress),
              const GapVertical24(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _onClose,
                      child: Text(context.str.close),
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
