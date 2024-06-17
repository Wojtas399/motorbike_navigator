import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../extensions/context_extensions.dart';
import '../map/cubit/map_cubit.dart';
import '../map/cubit/map_state.dart';

class SearchForm extends StatelessWidget {
  const SearchForm({super.key});

  void _onPlacePressed(String placeId, BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<MapCubit>().loadPlaceDetails(placeId);
  }

  @override
  Widget build(BuildContext context) {
    final cubitStatus = context.select(
      (MapCubit cubit) => cubit.state.status,
    );
    final suggestedPlaces = context.select(
      (MapCubit cubit) => cubit.state.placeSuggestions,
    );

    return Scaffold(
      appBar: const _SearchContainer(),
      body: SafeArea(
        child: Container(
          child: cubitStatus.isLoading
              ? const LinearProgressIndicator()
              : cubitStatus.isSuccess
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          ...ListTile.divideTiles(
                            color:
                                context.colorScheme.outline.withOpacity(0.25),
                            tiles: [
                              ...?suggestedPlaces?.map(
                                (place) => ListTile(
                                  title: Text(place.name),
                                  subtitle: place.fullAddress != null
                                      ? Text(place.fullAddress!)
                                      : null,
                                  onTap: () =>
                                      _onPlacePressed(place.id, context),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : null,
        ),
      ),
    );
  }
}

class _SearchContainer extends StatelessWidget implements PreferredSizeWidget {
  const _SearchContainer();

  @override
  Size get preferredSize => const Size.fromHeight(300);

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(24, kToolbarHeight + 24, 24, 24),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: context.colorScheme.outline,
              width: 0.4,
            ),
          ),
        ),
        child: const _SearchBar(),
      );
}

class _SearchBar extends StatefulWidget implements PreferredSizeWidget {
  const _SearchBar();

  @override
  State<StatefulWidget> createState() => _SearchBarState();

  @override
  Size get preferredSize => const Size.fromHeight(300);
}

class _SearchBarState extends State<_SearchBar> {
  late final FocusNode _focusNode;
  final TextEditingController _controller = TextEditingController();
  bool _isClearButtonVisible = false;

  @override
  void initState() {
    _focusNode = FocusNode();
    SchedulerBinding.instance.addPostFrameCallback((Duration _) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    _controller.addListener(_onControllerValueChanged);
    super.initState();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerValueChanged);
    super.dispose();
  }

  void _onControllerValueChanged() {
    if (_isClearButtonVisible && _controller.text.isEmpty) {
      setState(() {
        _isClearButtonVisible = false;
      });
    } else if (!_isClearButtonVisible && _controller.text.isNotEmpty) {
      setState(() {
        _isClearButtonVisible = true;
      });
    }
  }

  void _onBackButtonPressed(BuildContext context) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  void _onSubmitted(String? query) {
    if (query != null && query.isNotEmpty) {
      context.read<MapCubit>().searchPlaceSuggestions(query);
    }
  }

  void _onClearButtonPressed() {
    _controller.clear();
    context.read<MapCubit>().resetPlaceSuggestions();
  }

  @override
  Widget build(BuildContext context) => SearchBar(
        focusNode: _focusNode,
        controller: _controller,
        hintText: context.str.mapSearch,
        textInputAction: TextInputAction.search,
        leading: IconButton(
          onPressed: () => _onBackButtonPressed(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        trailing: [
          if (_isClearButtonVisible)
            IconButton(
              onPressed: _onClearButtonPressed,
              icon: const Icon(Icons.close),
            ),
        ],
        elevation: WidgetStateProperty.all(0),
        side: WidgetStateProperty.all(
          BorderSide(
            color: context.colorScheme.outline,
            width: 1.0,
          ),
        ),
        onSubmitted: _onSubmitted,
      );
}
