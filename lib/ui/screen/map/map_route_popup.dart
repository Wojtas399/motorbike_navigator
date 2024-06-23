import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/gap.dart';
import '../../extensions/context_extensions.dart';
import 'cubit/map_cubit.dart';
import 'cubit/navigation_cubit.dart';
import 'map_route_form.dart';

class MapRoutePopup extends StatefulWidget {
  const MapRoutePopup({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<MapRoutePopup> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _positionAnimation = Tween<double>(begin: -350, end: 0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInCubic,
      ),
    );
    _animationController.forward();
    super.initState();
  }

  Future<void> _onSubmit() async {
    await context.read<NavigationCubit>().loadNavigation();
  }

  void _onClose() {
    _animationController.reverse().whenComplete(
          context.read<MapCubit>().closeRouteSelection,
        );
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) => Transform.translate(
          offset: Offset(0, _positionAnimation.value),
          child: _BodyContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MapRouteForm(),
                const GapVertical24(),
                _Buttons(
                  onSubmitButtonPressed: _onSubmit,
                  onCloseButtonPressed: _onClose,
                ),
              ],
            ),
          ),
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
        padding: const EdgeInsets.fromLTRB(24, kToolbarHeight + 24, 16, 24),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(0, -2),
              blurRadius: 20,
            ),
          ],
        ),
        child: child,
      );
}

class _Buttons extends StatelessWidget {
  final VoidCallback onSubmitButtonPressed;
  final VoidCallback onCloseButtonPressed;

  const _Buttons({
    required this.onSubmitButtonPressed,
    required this.onCloseButtonPressed,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onCloseButtonPressed,
                child: Text(context.str.close),
              ),
            ),
            const GapHorizontal16(),
            Expanded(
              child: FilledButton(
                onPressed: onSubmitButtonPressed,
                child: Text(context.str.mapSearchRoute),
              ),
            ),
          ],
        ),
      );
}
