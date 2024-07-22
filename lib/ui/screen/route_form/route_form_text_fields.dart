import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../entity/map_point.dart';
import '../../animation/slide_left_page_route_animation.dart';
import '../../component/gap.dart';
import '../../cubit/route/route_cubit.dart';
import '../../cubit/route/route_state.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/route_place_extensions.dart';
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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _setInitialValue(),
    );
  }

  void _setInitialValue() {
    final RoutePlace? startPlace = context.read<RouteCubit>().state.startPlace;
    _controller.text = startPlace?.toUIName(context) ?? '';
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
    _controller.text = startPlace?.toUIName(context) ?? '';
  }

  Future<void> _onTap() async {
    _focusNode.unfocus();
    final RoutePlace? currentStartPoint =
        context.read<RouteCubit>().state.startPlace;
    final MapPoint? startPlacePoint = await Navigator.push(
      context,
      SlideLeftPageRouteAnimation(
        page: SearchForm(
          query: currentStartPoint is UserLocationRoutePlace
              ? null
              : _controller.text,
        ),
      ),
    );
    if (startPlacePoint is SelectedPlacePoint && mounted) {
      context.read<RouteCubit>().onStartPlaceChanged(
            SelectedRoutePlace(
              id: startPlacePoint.id,
              name: startPlacePoint.name,
            ),
          );
      _controller.text = startPlacePoint.name;
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
      onTap: _onTap,
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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _setInitialValue(),
    );
  }

  void _setInitialValue() {
    final RoutePlace? destination =
        context.read<RouteCubit>().state.destination;
    _controller.text = destination?.toUIName(context) ?? '';
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
    _controller.text = destination?.toUIName(context) ?? '';
  }

  Future<void> _onTap(BuildContext context) async {
    final RoutePlace? currentDestination =
        context.read<RouteCubit>().state.destination;
    _focusNode.unfocus();
    final MapPoint? destinationPoint = await Navigator.push(
      context,
      SlideLeftPageRouteAnimation(
        page: SearchForm(
          query: currentDestination is UserLocationRoutePlace
              ? null
              : _controller.text,
        ),
      ),
    );
    if (destinationPoint is SelectedPlacePoint && context.mounted) {
      context.read<RouteCubit>().onDestinationChanged(
            SelectedRoutePlace(
              id: destinationPoint.id,
              name: destinationPoint.name,
            ),
          );
      _controller.text = destinationPoint.name;
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
