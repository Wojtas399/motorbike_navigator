import 'package:flutter/material.dart';

import '../component/gap.dart';
import '../extensions/context_extensions.dart';

class RouteForm extends StatelessWidget {
  const RouteForm({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              GapVertical24(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BackButton(),
                  Expanded(
                    child: Row(
                      children: [
                        _RouteIcons(),
                        SizedBox(width: 8),
                        Expanded(
                          child: _Form(),
                        ),
                        SizedBox(width: 8),
                        _SwapPointsButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  void _onPressed(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () => _onPressed(context),
        icon: const Icon(Icons.arrow_back_ios_new),
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

class _Form extends StatelessWidget {
  const _Form();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          _RouteTextField(
            hintText: 'Wybierz miejsce startowe',
          ),
          GapVertical24(),
          _RouteTextField(
            hintText: 'Wybierz miejsce docelowe',
          ),
        ],
      );
}

class _RouteTextField extends StatelessWidget {
  final String? hintText;

  const _RouteTextField({
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hintText,
      ),
    );
  }
}

class _SwapPointsButton extends StatelessWidget {
  const _SwapPointsButton();

  void _onPressed() {
    //TODO
  }

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () => _onPressed(),
        icon: const Icon(
          Icons.swap_vert,
          size: 32,
        ),
      );
}
