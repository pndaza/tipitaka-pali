import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/business_logic/models/index.dart';
import 'package:tipitaka_pali/business_logic/models/search_result.dart';
import 'package:tipitaka_pali/business_logic/view_models/search_result_provider.dart';
import 'package:tipitaka_pali/ui/screens/home/widgets/search_result_list_tile.dart';

import 'search_filter_provider.dart';
import 'search_filter_view.dart';

class SearchResultPage extends StatelessWidget {
  final String searchWord;
  // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  SearchResultPage({
    Key? key,
    required this.searchWord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<SearchResultNotifier>(
              create: (_) => SearchResultNotifier(searchWord)),
          ChangeNotifierProvider<SearchFilterNotifier>(
              create: (_) => SearchFilterNotifier()),
        ],
        child: Consumer<SearchResultNotifier>(builder: (buildContext, _, __) {
          final notifier = buildContext.watch<SearchResultNotifier>();
          final List<Index> indexList =
              buildContext.watch<SearchResultNotifier>().indexList;
          if (indexList.isEmpty) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(child: Text('cannot find $searchWord.')),
            );
          }

          return Consumer<SearchFilterNotifier>(builder: (ctx, _, __) {
            // final searchFilterNotifier = ctx.watch<SearchFilterNotifier>();
            final List<String> selectedMainCategoryFilters =
                ctx.watch<SearchFilterNotifier>().selectedMainCategoryFilters;
            final List<String> selectedSubCategoryFilters =
                ctx.watch<SearchFilterNotifier>().selectedSubCategoryFilters;

            final filteredList = doFilter(indexList,
                selectedMainCategoryFilters, selectedSubCategoryFilters);

            print('filters result count: ${filteredList.length}');

            return Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (scaffoldContext, innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      floating: true,
                      pinned: false,
                      snap: true,
                      title: Text('found - ${indexList.length}'),
                      actions: [
                        IconButton(
                            onPressed: () {
                              Scaffold.of(scaffoldContext)
                                  .showBottomSheet((_) => SearchFilterView());
                            },
                            icon: Icon(Icons.filter_list))
                      ],
                    )
                  ];
                },
                body: ListView.separated(
                  itemCount: filteredList.length,
                  itemBuilder: (context, i) {
                    final index = filteredList[i];
                    return FutureBuilder(
                      future: notifier.getDetailResult(index),
                      builder: (BuildContext context,
                          AsyncSnapshot<SearchResult> snapshot) {
                        if (snapshot.hasData) {
                          final result = snapshot.data!;
                          return GestureDetector(
                            child: SearchResultListTile(
                              result: result,
                              textToHighlight: searchWord,
                            ),
                            onTap: () {
                              notifier.openBook(result, context);
                            },
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    );
                  },
                  separatorBuilder: (context, index) => Container(
                    height: 2,
                  ),
                ),
              ),
              // floatingActionButton: MyFab(),
            );
          });
          // do filter
        }));
  }

  List<Index> doFilter(
      List<Index> indexList,
      List<String> selectedMainFilteredList,
      List<String> selectedSubCategoryFilters) {
    final List<Index> filterdList = [];
    final List<Index> secondfilterdList = [];
    selectedMainFilteredList.forEach((element) {
      filterdList.addAll(
          indexList.where((index) => index.bookID!.contains(element)).toList());
    });

    selectedSubCategoryFilters.forEach((element) {
      secondfilterdList.addAll(filterdList
          .where((index) => index.bookID!.contains(element))
          .toList());
    });

    secondfilterdList.sort((a, b) => a.pageID.compareTo(b.pageID));
    return secondfilterdList;
  }
}

class MyFab extends StatefulWidget {
  const MyFab({Key? key}) : super(key: key);

  @override
  _MyFabState createState() => _MyFabState();
}

class _MyFabState extends State<MyFab> {
  bool isBottomSheetShowing = false;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      icon: Icon(Icons.filter_list),
      label: Text('Filter'),
      onPressed: () {
        Scaffold.of(context).showBottomSheet((_) => SearchFilterView());
      },
    );
  }
}
