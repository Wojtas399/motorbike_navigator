import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../entity/place_suggestion.dart';
import '../../animation/slide_left_page_route_animation.dart';
import '../../component/gap.dart';
import '../../cubit/route/route_cubit.dart';
import '../../cubit/route/route_state.dart';
import '../../extensions/context_extensions.dart';
import '../search_form/search_form.dart';

class RouteFormTextFields extends StatelessWidget {
  const RouteFormTextFields({super.key});

  @override
  Widget build(BuildContext context) => const Column(
        children: [
          _StartPlaceTextField(),
          GapVertical16(),
          _DestinationTextField(),
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
          .read<RouteCubit>()
          .onStartPlaceSuggestionChanged(startPlaceSuggestion);
      _controller.text = startPlaceSuggestion.name;
    }
  }

  void _onStartPlaceSuggestionChanged(PlaceSuggestion? startPlaceSuggestion) {
    _controller.text = startPlaceSuggestion?.name ?? '';
  }

  @override
  Widget build(BuildContext context) => BlocListener<RouteCubit, RouteState>(
        listenWhen: (prevState, currState) =>
            prevState.startPlaceSuggestion != currState.startPlaceSuggestion,
        listener: (_, state) =>
            _onStartPlaceSuggestionChanged(state.startPlaceSuggestion),
        child: _CustomTextField(
          hintText: context.str.mapSelectStartPlace,
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
          .read<RouteCubit>()
          .onDestinationSuggestionChanged(destinationSuggestion);
      _controller.text = destinationSuggestion.name;
    }
  }

  void _onDestinationSuggestionChanged(PlaceSuggestion? destinationSuggestion) {
    _controller.text = destinationSuggestion?.name ?? '';
  }

  @override
  Widget build(BuildContext context) => BlocListener<RouteCubit, RouteState>(
        listenWhen: (prevState, currState) =>
            prevState.destinationSuggestion != currState.destinationSuggestion,
        listener: (_, state) =>
            _onDestinationSuggestionChanged(state.destinationSuggestion),
        child: _CustomTextField(
          hintText: context.str.mapSelectDestination,
          controller: _controller,
          focusNode: _focusNode,
          onTap: () => _onTap(context),
        ),
      );
}

class _CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onTap;

  const _CustomTextField({
    required this.hintText,
    required this.controller,
    required this.focusNode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: context.str.mapSelectDestination,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        controller: controller,
        focusNode: focusNode,
        onTap: onTap,
      );
}
