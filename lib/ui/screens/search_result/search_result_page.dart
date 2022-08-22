import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../widgets/loading_view.dart';
import '../home/search_page/search_page.dart';
import 'controller/search_filter_provider.dart';
import 'controller/search_result_provider.dart';
import 'widgets/empty_result_view.dart';
import 'widgets/result_list_view.dart';

class SearchResultPage extends StatelessWidget {
  final String searchWord;
  final QueryMode queryMode;
  final int wordDistance;
  //  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  const SearchResultPage(
      {Key? key,
      required this.searchWord,
      required this.queryMode,
      required this.wordDistance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<SearchFilterController>(
              create: (_) => SearchFilterController()),
          ChangeNotifierProxyProvider<SearchFilterController,
                  SearchResultController>(
              create: (_) => SearchResultController(
                  searchWord: searchWord,
                  queryMode: queryMode,
                  wordDistance: wordDistance,
                  filterController: SearchFilterController())
                ..init(),
              update: (_, filterController, resultConroller) {
                resultConroller!.onChangeFilter(filterController);
                return resultConroller;
              }),
        ],
        builder: (context, _) {
          // final notifier = context.watch<SearchResultNotifier>();
          final state = context.watch<SearchResultController>().state;

          return state.when(
            loading: () => const Material(child: LoadingView()),
            noData: () => EmptyResultView(searchWord: searchWord),
            loaded: (results, bookCount) => ResultListView(
              searchWord: searchWord,
              results: results,
              bookCount: bookCount,
            ),
          );
        });
  }
}
