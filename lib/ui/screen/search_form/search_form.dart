import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../screen/map/cubit/map_cubit.dart';
import '../../screen/map/cubit/map_state.dart';
import 'search_form_search_container.dart';
import 'search_form_suggested_places.dart';

class SearchForm extends StatelessWidget {
  const SearchForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubitStatus = context.select(
      (MapCubit cubit) => cubit.state.status,
    );

    return Scaffold(
      appBar: const SearchFormSearchContainer(),
      body: SafeArea(
        child: Container(
          child: cubitStatus.isLoading
              ? const LinearProgressIndicator()
              : cubitStatus.isSuccess
                  ? const SearchFormSuggestedPlaces()
                  : null,
        ),
      ),
    );
  }
}
