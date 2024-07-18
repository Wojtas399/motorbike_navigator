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
  String? _errorText;

  @override
  void initState() {
    final String? startPlaceSuggestionName =
        context.read<RouteCubit>().state.startPlaceSuggestion?.name;
    if (startPlaceSuggestionName != null) {
      _controller.text = startPlaceSuggestionName;
    }
    super.initState();
  }

  void _handleRouteStatusChange(
    RouteStateStatus status,
    PlaceSuggestion? startPlaceSuggestion,
  ) {
    if (status == RouteStateStatus.formNotCompleted &&
        startPlaceSuggestion == null) {
      setState(() {
        _errorText = context.str.requiredField;
      });
    } else if (_errorText != null) {
      setState(() {
        _errorText = null;
      });
    }
  }

  void _handleStartPlaceSuggestionChange(PlaceSuggestion? suggestion) {
    _controller.text = suggestion?.name ?? '';
  }

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

  @override
  Widget build(BuildContext context) {
    final RouteStateStatus routeStatus = context.select(
      (RouteCubit cubit) => cubit.state.status,
    );
    final PlaceSuggestion? startPlaceSuggestion = context.select(
      (RouteCubit cubit) => cubit.state.startPlaceSuggestion,
    );
    _handleRouteStatusChange(routeStatus, startPlaceSuggestion);
    _handleStartPlaceSuggestionChange(startPlaceSuggestion);

    return _CustomTextField(
      hintText: context.str.mapSelectStartPlace,
      errorText: _errorText,
      controller: _controller,
      focusNode: _focusNode,
      onTap: () => _onTap(context),
    );
  }
}

class _DestinationTextField extends StatefulWidget {
  const _DestinationTextField();

  @override
  State<StatefulWidget> createState() => _DestinationTextFieldState();
}

class _DestinationTextFieldState extends State<_DestinationTextField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String? _errorText;

  @override
  void initState() {
    final String? destinationSuggestionName =
        context.read<RouteCubit>().state.destinationSuggestion?.name;
    if (destinationSuggestionName != null) {
      _controller.text = destinationSuggestionName;
    }
    super.initState();
  }

  void _handleRouteStatusChange(
    RouteStateStatus status,
    PlaceSuggestion? destinationSuggestion,
  ) {
    if (status == RouteStateStatus.formNotCompleted &&
        destinationSuggestion == null) {
      setState(() {
        _errorText = context.str.requiredField;
      });
    } else if (_errorText != null) {
      setState(() {
        _errorText = null;
      });
    }
  }

  void _handleDestinationSuggestionChange(PlaceSuggestion? suggestion) {
    _controller.text = suggestion?.name ?? '';
  }

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

  @override
  Widget build(BuildContext context) {
    final RouteStateStatus routeStatus = context.select(
      (RouteCubit cubit) => cubit.state.status,
    );
    final PlaceSuggestion? destinationSuggestion = context.select(
      (RouteCubit cubit) => cubit.state.destinationSuggestion,
    );
    _handleRouteStatusChange(routeStatus, destinationSuggestion);
    _handleDestinationSuggestionChange(destinationSuggestion);

    return _CustomTextField(
      hintText: context.str.mapSelectDestination,
      errorText: _errorText,
      controller: _controller,
      focusNode: _focusNode,
      onTap: () => _onTap(context),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final String hintText;
  final String? errorText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onTap;

  const _CustomTextField({
    required this.hintText,
    this.errorText,
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
          errorText: errorText,
        ),
        controller: controller,
        focusNode: focusNode,
        onTap: onTap,
      );
}
