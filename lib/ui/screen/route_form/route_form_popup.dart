import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../component/gap.dart';
import '../../extensions/context_extensions.dart';
import '../map/cubit/map_cubit.dart';
import 'cubit/route_form_cubit.dart';
import 'route_form_text_fields.dart';

class RouteFormPopup extends StatefulWidget {
  const RouteFormPopup({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<RouteFormPopup> with SingleTickerProviderStateMixin {
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
    await context.read<RouteFormCubit>().loadNavigation();
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
                const Row(
                  children: [
                    _RouteIcons(),
                    GapHorizontal16(),
                    Expanded(
                      child: RouteFormTextFields(),
                    ),
                    GapHorizontal8(),
                    _SwapPlaceSuggestionsButton(),
                  ],
                ),
                const GapVertical16(),
                _FormActionButtons(
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
        padding: const EdgeInsets.fromLTRB(24, kToolbarHeight + 16, 16, 24),
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

class _SwapPlaceSuggestionsButton extends StatelessWidget {
  const _SwapPlaceSuggestionsButton();

  void _onPressed(BuildContext context) {
    context.read<RouteFormCubit>().swapPlaceSuggestions();
  }

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () => _onPressed(context),
        icon: const Icon(
          Icons.swap_vert,
          size: 32,
        ),
      );
}

class _FormActionButtons extends StatelessWidget {
  final VoidCallback onSubmitButtonPressed;
  final VoidCallback onCloseButtonPressed;

  const _FormActionButtons({
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
