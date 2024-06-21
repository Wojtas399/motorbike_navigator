import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import 'gap.dart';

class RouteFormComponent extends StatelessWidget {
  final String? initialStartPlaceValue;
  final String? initialDestinationValue;
  final VoidCallback? onStartPlaceTap;
  final VoidCallback? onDestinationTap;
  final VoidCallback? onSwapLocationsTap;

  const RouteFormComponent({
    super.key,
    this.initialStartPlaceValue,
    this.initialDestinationValue,
    this.onStartPlaceTap,
    this.onDestinationTap,
    this.onSwapLocationsTap,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const _RouteIcons(),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                _PlaceTextField(
                  initialValue: initialStartPlaceValue,
                  hintText: 'Wybierz miejsce startowe',
                  onTap: onStartPlaceTap,
                ),
                const GapVertical24(),
                _PlaceTextField(
                  initialValue: initialDestinationValue,
                  hintText: 'Wybierz miejsce docelowe',
                  onTap: onDestinationTap,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _SwapPointsButton(
            onPressed: onSwapLocationsTap,
          ),
        ],
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
          const GapVertical16(),
          const Icon(Icons.more_vert),
          const GapVertical16(),
          const Icon(
            Icons.location_on_outlined,
            color: Colors.red,
          ),
        ],
      );
}

class _PlaceTextField extends StatefulWidget {
  final String? initialValue;
  final String? hintText;
  final VoidCallback? onTap;

  const _PlaceTextField({
    this.initialValue,
    this.hintText,
    this.onTap,
  });

  @override
  State<StatefulWidget> createState() => _PlaceTextFieldState();
}

class _PlaceTextFieldState extends State<_PlaceTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.text = widget.initialValue ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) => TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: widget.hintText,
        ),
        controller: _controller,
        onTap: widget.onTap,
      );
}

class _SwapPointsButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _SwapPointsButton({
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () => onPressed,
        icon: const Icon(
          Icons.swap_vert,
          size: 32,
        ),
      );
}
