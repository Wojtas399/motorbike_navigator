import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../entity/place_suggestion.dart';
import '../../animation/slide_left_page_route_animation.dart';
import '../../component/gap.dart';
import '../../extensions/context_extensions.dart';
import '../search_form/search_form.dart';
import 'cubit/route_form_cubit.dart';
import 'cubit/route_form_state.dart';

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
                  child: Column(
                    children: [
                      _StartPlaceQueryTextField(),
                      GapVertical24(),
                      _DestinationQueryTextField(),
                    ],
                  ),
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

class _StartPlaceQueryTextField extends StatefulWidget {
  const _StartPlaceQueryTextField();

  @override
  State<StatefulWidget> createState() => _StartPlaceQueryTextFieldState();
}

class _StartPlaceQueryTextFieldState extends State<_StartPlaceQueryTextField> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _onTap() async {
    FocusScope.of(context).unfocus();
    final PlaceSuggestion? placeSuggestion = await Navigator.push(
      context,
      SlideLeftPageRouteAnimation(
        page: SearchForm(query: _controller.text),
      ),
    );
    if (mounted) {
      context.read<RouteFormCubit>().onStartPlaceChanged(placeSuggestion);
    }
  }

  void _onStartPlaceChanged(PlaceSuggestion? startPlace) {
    _controller.text = startPlace?.name ?? '';
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<RouteFormCubit, RouteFormState>(
        listenWhen: (prevState, currState) =>
            prevState.startPlace != currState.startPlace,
        listener: (_, state) => _onStartPlaceChanged(state.startPlace),
        child: _PlaceTextField(
          hintText: 'Wybierz miejsce startowe',
          controller: _controller,
          onTap: _onTap,
        ),
      );
}

class _DestinationQueryTextField extends StatefulWidget {
  const _DestinationQueryTextField();

  @override
  State<StatefulWidget> createState() => _DestinationQueryTextFieldState();
}

class _DestinationQueryTextFieldState
    extends State<_DestinationQueryTextField> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _onTap() async {
    FocusScope.of(context).unfocus();
    final PlaceSuggestion? placeSuggestion = await Navigator.push(
      context,
      SlideLeftPageRouteAnimation(
        page: SearchForm(query: _controller.text),
      ),
    );
    if (mounted) {
      context.read<RouteFormCubit>().onDestinationChanged(placeSuggestion);
    }
  }

  void _onDestinationChanged(PlaceSuggestion? destination) {
    _controller.text = destination?.name ?? '';
  }

  @override
  Widget build(BuildContext context) =>
      BlocListener<RouteFormCubit, RouteFormState>(
        listenWhen: (prevState, currState) =>
            prevState.destination != currState.destination,
        listener: (_, state) => _onDestinationChanged(state.destination),
        child: _PlaceTextField(
          hintText: 'Wybierz miejsce docelowe',
          controller: _controller,
          onTap: _onTap,
        ),
      );
}

class _PlaceTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final VoidCallback? onTap;

  const _PlaceTextField({
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

  void _onPressed(BuildContext context) {
    context.read<RouteFormCubit>().swapPlaces();
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
