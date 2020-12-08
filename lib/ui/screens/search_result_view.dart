import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/business_logic/models/index.dart';
import 'package:tipitaka_pali/business_logic/view_models/search_result_provider.dart';
import 'package:tipitaka_pali/ui/screens/home/widgets/search_result_list_tile.dart';
import 'package:tipitaka_pali/utils/mm_number.dart';

class SearchResultView extends StatelessWidget {
  final String searchWord;

  const SearchResultView({
    Key key,
    this.searchWord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<SearchResultProvider>(
      create: (context) => SearchResultProvider(searchWord),
      child: Consumer<SearchResultProvider>(
        builder: (context, provider, child) {
          return FutureBuilder(
              future: provider.getResults(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Index>> snapshot) {
                if (snapshot.hasData) {
                  List<Index> indexes = snapshot.data;
                  if (indexes.isNotEmpty) {
                    print('found: ${indexes.length} times');
                    return Scaffold(
                      body: NestedScrollView(
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          return <Widget>[
                            SliverAppBar(
                              floating: true,
                              pinned: false,
                              snap: true,
                              title: Text('တွေ့ရှိမှု - ${MmNumber.get(indexes.length)} ကြိမ်'),
                            )
                          ];
                        },
                        body: ListView.separated(
                            itemCount: indexes.length,
                            itemBuilder: (context, i) {
                              final index = indexes[i];
                              return FutureBuilder(
                                future: provider.getDetailResult(index),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final result = snapshot.data;
                                    return GestureDetector(
                                      child: SearchResultListTile(
                                        result: result,
                                        textToHighlight: searchWord,
                                      ),
                                      onTap: () {
                                        provider.openBook(result, context);
                                      },
                                    );
                                  }
                                  return Container();
                                },
                              );
                            },
                            separatorBuilder: (context, index) => Container(height: 2,),),
                      ),
                    );
                  }
                }
                return Scaffold(
                  appBar: AppBar(),
                  body: Center(
                      child: Text('$searchWord ဟူသော စကားလုံးကို ရှာမတွေ့ပါ')),
                );
              });
        },
      ),
    );
  }
}
