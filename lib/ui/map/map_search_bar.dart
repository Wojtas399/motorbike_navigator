import 'package:flutter/material.dart';
import 'package:motorbike_navigator/ui/extensions/context_extensions.dart';

class MapSearchBar extends StatelessWidget {
  const MapSearchBar({super.key});

  @override
  Widget build(BuildContext context) => SearchBar(
        hintText: context.str.mapSearch,
        leading: const Icon(Icons.location_on),
      );
}
