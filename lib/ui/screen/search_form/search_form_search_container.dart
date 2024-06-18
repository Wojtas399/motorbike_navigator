import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../extensions/context_extensions.dart';
import 'cubit/search_form_cubit.dart';

class SearchFormSearchContainer extends StatelessWidget
    implements PreferredSizeWidget {
  const SearchFormSearchContainer({super.key});

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
    // _controller.text = context.read<MapCubit>().state.searchQuery;
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
    // final mapCubit = context.read<MapCubit>();
    // final bool isPlaceNotSelected = mapCubit.state.selectedPlace == null;
    // if (isPlaceNotSelected) mapCubit.resetPlaceSuggestions();
    Navigator.pop(context);
  }

  void _onQueryChanged(String query, BuildContext context) {
    context.read<SearchFormCubit>().onSearchQueryChanged(query);
  }

  void _onSearch() {
    context.read<SearchFormCubit>().searchPlaceSuggestions();
  }

  void _onClearButtonPressed() {
    _controller.clear();
    context.read<SearchFormCubit>().resetPlaceSuggestions();
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
        onChanged: (String query) => _onQueryChanged(query, context),
        onSubmitted: (_) => _onSearch(),
      );
}
