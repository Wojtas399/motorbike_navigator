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
          _PlaceTextField(
            hintText: 'Wybierz miejsce startowe',
          ),
          GapVertical24(),
          _PlaceTextField(
            hintText: 'Wybierz miejsce docelowe',
          ),
        ],
      );
}

class _PlaceTextField extends StatefulWidget {
  final String? hintText;

  const _PlaceTextField({
    this.hintText,
  });

  @override
  State<StatefulWidget> createState() => _PlaceTextFieldState();
}

class _PlaceTextFieldState extends State<_PlaceTextField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Future<void> _onTap() async {
    _focusNode.unfocus();
    final PlaceSuggestion? placeSuggestion = await Navigator.push(
      context,
      SlideLeftPageRouteAnimation(
        page: SearchForm(query: _controller.text),
      ),
    );
    if (context.mounted) _controller.text = placeSuggestion?.name ?? '';
  }

  @override
  Widget build(BuildContext context) => TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: widget.hintText,
        ),
        controller: _controller,
        focusNode: _focusNode,
        onTap: _onTap,
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
