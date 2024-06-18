import 'package:flutter/material.dart';

import '../../../entity/place_suggestion.dart';
import '../../animation/slide_left_page_route_animation.dart';
import '../../component/gap.dart';
import '../../extensions/context_extensions.dart';
import '../search_form/search_form.dart';

class RouteFormPlacesSelection extends StatelessWidget {
  const RouteFormPlacesSelection({super.key});

  @override
  Widget build(BuildContext context) => const Row(
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
  Widget build(BuildContext context) => const Column(
        children: [
          _StartPlace(),
          GapVertical24(),
          _DestinationPlace(),
        ],
      );
}

class _StartPlace extends StatefulWidget {
  const _StartPlace();

  @override
  State<StatefulWidget> createState() => _StartPlaceState();
}

class _StartPlaceState extends State<_StartPlace> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _onStartPlaceTap(BuildContext context) async {
    final PlaceSuggestion? placeSuggestion = await Navigator.push(
      context,
      SlideLeftPageRouteAnimation(
        page: const SearchForm(query: ''),
      ),
    );
    if (placeSuggestion != null && context.mounted) {
      //TODO
    }
  }

  @override
  Widget build(BuildContext context) => _RouteTextField(
        hintText: 'Wybierz miejsce startowe',
        controller: _controller,
        onTap: () => _onStartPlaceTap(context),
      );
}

class _DestinationPlace extends StatefulWidget {
  const _DestinationPlace();

  @override
  State<StatefulWidget> createState() => _DestinationPlaceState();
}

class _DestinationPlaceState extends State<_DestinationPlace> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _onStartPlaceTap(BuildContext context) async {
    final PlaceSuggestion? placeSuggestion = await Navigator.push(
      context,
      SlideLeftPageRouteAnimation(
        page: const SearchForm(query: ''),
      ),
    );
    if (placeSuggestion != null && context.mounted) {
      //TODO
    }
  }

  @override
  Widget build(BuildContext context) => _RouteTextField(
        hintText: 'Wybierz miejsce docelowe',
        controller: _controller,
        onTap: () => _onStartPlaceTap(context),
      );
}

class _RouteTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final VoidCallback? onTap;

  const _RouteTextField({
    this.hintText,
    this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
        ),
        controller: controller,
        onTap: onTap,
      );
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
