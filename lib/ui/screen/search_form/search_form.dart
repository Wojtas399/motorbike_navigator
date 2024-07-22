import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import 'cubit/search_form_cubit.dart';
import 'cubit/search_form_state.dart';
import 'search_form_search_container.dart';
import 'search_form_suggested_places.dart';

class SearchForm extends StatelessWidget {
  final String? query;

  const SearchForm({super.key, required this.query});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt.get<SearchFormCubit>()..initialize(query),
        child: const Scaffold(
          appBar: SearchFormSearchContainer(),
          body: SafeArea(
            child: _Body(),
          ),
        ),
      );
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final cubitStatus = context.select(
      (SearchFormCubit cubit) => cubit.state.status,
    );

    return Container(
      child: cubitStatus.isLoading
          ? const LinearProgressIndicator()
          : cubitStatus.isCompleted
              ? const SearchFormSuggestedPlaces()
              : null,
    );
  }
}
