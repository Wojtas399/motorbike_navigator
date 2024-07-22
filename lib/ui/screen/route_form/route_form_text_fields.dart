import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../entity/map_point.dart';
import '../../animation/slide_left_page_route_animation.dart';
import '../../component/gap.dart';
import '../../cubit/route/route_cubit.dart';
import '../../cubit/route/route_state.dart';
import '../../extensions/context_extensions.dart';
import '../../extensions/map_point_extensions.dart';
import '../search_form/search_form.dart';

class RouteFormTextFields extends StatelessWidget {
  const RouteFormTextFields({super.key});

  @override
  Widget build(BuildContext context) => const Column(
        children: [
          _StartPointTextField(),
          GapVertical16(),
          _EndPointTextField(),
        ],
      );
}

class _StartPointTextField extends StatefulWidget {
  const _StartPointTextField();

  @override
  State<StatefulWidget> createState() => _StartPointTextFieldState();
}

class _StartPointTextFieldState extends State<_StartPointTextField> {
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
    final MapPoint? startPoint = context.read<RouteCubit>().state.startPoint;
    _controller.text = startPoint?.toUIName(context) ?? '';
  }

  void _handleRouteStatusChange(
    RouteStateStatus status,
    MapPoint? startPoint,
  ) {
    if (status == RouteStateStatus.formNotCompleted && startPoint == null) {
      setState(() {
        _errorText = context.str.requiredField;
      });
    } else if (_errorText != null) {
      setState(() {
        _errorText = null;
      });
    }
  }

  void _handleStartPointChange(MapPoint? startPoint) {
    _controller.text = startPoint?.toUIName(context) ?? '';
  }

  Future<void> _onTap() async {
    _focusNode.unfocus();
    final MapPoint? currentStartPoint =
        context.read<RouteCubit>().state.startPoint;
    final MapPoint? newStartPoint = await Navigator.push(
      context,
      SlideLeftPageRouteAnimation(
        page: SearchForm(
          query:
              currentStartPoint is UserLocationPoint ? null : _controller.text,
        ),
      ),
    );
    if (newStartPoint != null && mounted) {
      context.read<RouteCubit>().onStartPointChanged(newStartPoint);
      _controller.text = newStartPoint.toUIName(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final RouteStateStatus routeStatus = context.select(
      (RouteCubit cubit) => cubit.state.status,
    );
    final MapPoint? startPoint = context.select(
      (RouteCubit cubit) => cubit.state.startPoint,
    );
    _handleRouteStatusChange(routeStatus, startPoint);
    _handleStartPointChange(startPoint);

    return _CustomTextField(
      hintText: context.str.mapSelectStartPlace,
      errorText: _errorText,
      controller: _controller,
      focusNode: _focusNode,
      onTap: _onTap,
    );
  }
}

class _EndPointTextField extends StatefulWidget {
  const _EndPointTextField();

  @override
  State<StatefulWidget> createState() => _EndPointTextFieldState();
}

class _EndPointTextFieldState extends State<_EndPointTextField> {
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
    final MapPoint? endPoint = context.read<RouteCubit>().state.endPoint;
    _controller.text = endPoint?.toUIName(context) ?? '';
  }

  void _handleRouteStatusChange(
    RouteStateStatus status,
    MapPoint? destination,
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

  void _handleEndPointChange(MapPoint? endPoint) {
    _controller.text = endPoint?.toUIName(context) ?? '';
  }

  Future<void> _onTap(BuildContext context) async {
    final MapPoint? currentEndPoint = context.read<RouteCubit>().state.endPoint;
    _focusNode.unfocus();
    final MapPoint? newEndPoint = await Navigator.push(
      context,
      SlideLeftPageRouteAnimation(
        page: SearchForm(
          query: currentEndPoint is UserLocationPoint ? null : _controller.text,
        ),
      ),
    );
    if (newEndPoint != null && context.mounted) {
      context.read<RouteCubit>().onEndPointChanged(newEndPoint);
      _controller.text = newEndPoint.toUIName(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final RouteStateStatus routeStatus = context.select(
      (RouteCubit cubit) => cubit.state.status,
    );
    final MapPoint? endPoint = context.select(
      (RouteCubit cubit) => cubit.state.endPoint,
    );
    _handleRouteStatusChange(routeStatus, endPoint);
    _handleEndPointChange(endPoint);

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
