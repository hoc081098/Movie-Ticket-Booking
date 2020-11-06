import 'dart:async';

import 'package:datn/ui/app_scaffold.dart';
import 'package:datn/ui/home/search/search_page.dart';
import 'package:flutter/material.dart';

class MovieSearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isNotEmpty) {
      scheduleMicrotask(() {
        close(context, query);
        AppScaffold.of(context).pushNamed(
          SearchPage.routeName,
          arguments: query,
        );
      });
    }
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) => const SizedBox();
}
