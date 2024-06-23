import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../entity/place_suggestion.dart';
import '../../animation/slide_left_page_route_animation.dart';
import '../../component/gap.dart';
import '../../extensions/context_extensions.dart';
import '../search_form/search_form.dart';
import 'cubit/navigation_cubit.dart';
import 'cubit/navigation_state.dart';

class MapRouteForm extends StatelessWidget {
  const MapRouteForm({super.key});

  @override
  Widget build(BuildContext context) => const Row(
        children: [
          _RouteIcons(),
          GapHorizontal8(),
          Expanded(
            child: Column(
              children: [
                _StartPlaceTextField(),
                GapVertical24(),
                _DestinationTextField(),
              ],
            ),
          ),
          SizedBox(width: 8),
          _SwapPointsButton(),
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

class _StartPlaceTextField extends StatefulWidget {
  const _StartPlaceTextField();

  @override
  State<StatefulWidget> createState() => _StartPlaceTextFieldState();
}

class _StartPlaceTextFieldState extends State<_StartPlaceTextField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Future<void> _onTap(BuildContext context) async {
    _focusNode.unfocus();
    final PlaceSuggestion? startPlaceSuggestion = await Navigator.push(
      context,
      SlideLeftPageRouteAnimation(
        page: SearchForm(query: _controller.text),
      ),
    );
    if (startPlaceSuggestion != null && context.mounted) {
      context
          .read<NavigationCubit>()
          .onStartPlaceSuggestionChanged(startPlaceSuggestion);
      _controller.text = startPlaceSuggestion.name;
    }
  }

  void _onStartPlaceSuggestionChanged(PlaceSuggestion? startPlaceSuggestion) {
    _controller.text = startPlaceSuggestion?.name ?? '';
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<NavigationCubit, NavigationState>(
        listenWhen: (prevState, currState) =>
            prevState.startPlaceSuggestion != currState.startPlaceSuggestion,
        listener: (_, state) =>
            _onStartPlaceSuggestionChanged(state.startPlaceSuggestion),
        child: TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Wybierz miejsce startowe',
          ),
          controller: _controller,
          focusNode: _focusNode,
          onTap: () => _onTap(context),
        ),
      );
}

class _DestinationTextField extends StatefulWidget {
  const _DestinationTextField();

  @override
  State<StatefulWidget> createState() => _DestinationTextFieldState();
}

class _DestinationTextFieldState extends State<_DestinationTextField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  Future<void> _onTap(BuildContext context) async {
    _focusNode.unfocus();
    final PlaceSuggestion? destinationSuggestion = await Navigator.push(
      context,
      SlideLeftPageRouteAnimation(
        page: SearchForm(query: _controller.text),
      ),
    );
    if (destinationSuggestion != null && context.mounted) {
      context
          .read<NavigationCubit>()
          .onDestinationSuggestionChanged(destinationSuggestion);
      _controller.text = destinationSuggestion.name;
    }
  }

  void _onDestinationSuggestionChanged(PlaceSuggestion? destinationSuggestion) {
    _controller.text = destinationSuggestion?.name ?? '';
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<NavigationCubit, NavigationState>(
        listenWhen: (prevState, currState) =>
            prevState.destinationSuggestion != currState.destinationSuggestion,
        listener: (_, state) =>
            _onDestinationSuggestionChanged(state.destinationSuggestion),
        child: TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Wybierz miejsce docelowe',
          ),
          controller: _controller,
          focusNode: _focusNode,
          onTap: () => _onTap(context),
        ),
      );
}

class _SwapPointsButton extends StatelessWidget {
  const _SwapPointsButton();

  void _onPressed(BuildContext context) {
    context.read<NavigationCubit>().swapPlaceSuggestions();
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
