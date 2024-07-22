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
    final RoutePlace? startPlace = context.read<RouteCubit>().state.startPlace;
    if (startPlace is UserLocationRoutePlace) {
      _controller.text = 'Twoja lokalizacja';
    } else if (startPlace is SelectedRoutePlace) {
      _controller.text = startPlace.name;
    }
    super.initState();
  }

  void _handleRouteStatusChange(
    RouteStateStatus status,
    RoutePlace? startPlace,
  ) {
    if (status == RouteStateStatus.formNotCompleted && startPlace == null) {
      setState(() {
        _errorText = context.str.requiredField;
      });
    } else if (_errorText != null) {
      setState(() {
        _errorText = null;
      });
    }
  }

  void _handleStartPlaceChange(RoutePlace? startPlace) {
    if (startPlace is UserLocationRoutePlace) {
      _controller.text = 'Twoja lokalizacja';
    } else if (startPlace is SelectedRoutePlace) {
      _controller.text = startPlace.name;
    } else if (startPlace == null) {
      _controller.text = '';
    }
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
      context.read<RouteCubit>().onStartPlaceChanged(
            SelectedRoutePlace(
              id: startPlaceSuggestion.id,
              name: startPlaceSuggestion.name,
            ),
          );
      _controller.text = startPlaceSuggestion.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final RouteStateStatus routeStatus = context.select(
      (RouteCubit cubit) => cubit.state.status,
    );
    final RoutePlace? startPlace = context.select(
      (RouteCubit cubit) => cubit.state.startPlace,
    );
    _handleRouteStatusChange(routeStatus, startPlace);
    _handleStartPlaceChange(startPlace);

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
    final RoutePlace? destination =
        context.read<RouteCubit>().state.destination;
    if (destination is UserLocationRoutePlace) {
      _controller.text = 'Twoja lokalizacja';
    } else if (destination is SelectedRoutePlace) {
      _controller.text = destination.name;
    }
    super.initState();
  }

  void _handleRouteStatusChange(
    RouteStateStatus status,
    RoutePlace? destination,
  ) {
    if (status == RouteStateStatus.formNotCompleted && destination == null) {
      setState(() {
        _errorText = context.str.requiredField;
      });
    } else if (_errorText != null) {
      setState(() {
        _errorText = null;
      });
    }
  }

  void _handleDestinationChange(RoutePlace? destination) {
    if (destination is UserLocationRoutePlace) {
      _controller.text = 'Twoja lokalizacja';
    } else if (destination is SelectedRoutePlace) {
      _controller.text = destination.name;
    } else if (destination == null) {
      _controller.text = '';
    }
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
      context.read<RouteCubit>().onDestinationChanged(
            SelectedRoutePlace(
              id: destinationSuggestion.id,
              name: destinationSuggestion.name,
            ),
          );
      _controller.text = destinationSuggestion.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final RouteStateStatus routeStatus = context.select(
      (RouteCubit cubit) => cubit.state.status,
    );
    final RoutePlace? destination = context.select(
      (RouteCubit cubit) => cubit.state.destination,
    );
    _handleRouteStatusChange(routeStatus, destination);
    _handleDestinationChange(destination);

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
