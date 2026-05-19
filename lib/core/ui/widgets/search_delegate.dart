// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../features/search/cubit/search_cubit.dart';
// import '../../../features/search/widget/build_action_search.dart';
// import '../../../features/search/widget/build_leading_search.dart';
// import '../../../features/search/widget/build_result_search.dart';
// import '../../../features/search/widget/build_suggestions_search.dart';
// import '../../boilerplate/pagination/models/get_list_request.dart';

// class DataSearch extends SearchDelegate<String> {
//   String searchLabel = "";
//   void onFilter(BuildContext context) {
//     context.read<SearchCubit>().search(GetListRequest(skip: 0, take: 10));

//     context.read<SearchCubit>().searchCubit?.getList();
//   }

//   @override
//   String get searchFieldLabel {
//     return searchLabel;
//   }

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     final actions = SearchActions(onFilter: onFilter);
//     return actions.buildActions(context, (queryValue) => query = queryValue);
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     final leading = SearchLeading();
//     return leading.buildLeading(
//         context, (queryValue) => close(context, queryValue));
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     final actions = BuildResultSearch(onFilter: onFilter);
//     return actions.buildResult(context, (queryValue) => query = queryValue);
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
    
//     final suggestions = SearchSuggestions();
//     return suggestions.buildSuggestions(
//       context,
//       query,
//       (newQuery) => query = newQuery,
//       (ctx) => showResults(ctx),
//     );
//   }
// }