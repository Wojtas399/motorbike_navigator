import 'package:flutter/material.dart';

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

  Future<void> _onStartPlaceTap(BuildContext context) async {
    final SearchFormResults? results = await _askForSearchFormResults(context);
    if (results != null && context.mounted) {
      //TODO
    }
  }

  Future<void> _onDestinationPlaceTap(BuildContext context) async {
    final SearchFormResults? results = await _askForSearchFormResults(context);
    if (results != null && context.mounted) {
      //TODO
    }
  }

  Future<SearchFormResults?> _askForSearchFormResults(
    BuildContext context,
  ) async =>
      await Navigator.push(
        context,
        SlideLeftPageRouteAnimation(
          page: const SearchForm(query: ''),
        ),
      );

  @override
  Widget build(BuildContext context) => Column(
        children: [
          _RouteTextField(
            hintText: 'Wybierz miejsce startowe',
            onTap: () => _onStartPlaceTap(context),
          ),
          const GapVertical24(),
          _RouteTextField(
            hintText: 'Wybierz miejsce docelowe',
            onTap: () => _onDestinationPlaceTap(context),
          ),
        ],
      );
}

class _RouteTextField extends StatelessWidget {
  final String? hintText;
  final VoidCallback? onTap;

  const _RouteTextField({
    this.hintText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
        ),
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
