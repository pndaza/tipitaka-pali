import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/business_logic/view_models/search_page_view_model.dart';
import 'package:tipitaka_pali/ui/screens/home/widgets/search_bar.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchViewModel>(
      create: (_) => SearchViewModel(),
      child: Scaffold(
          appBar: AppBar(
            title: Text('စာရှာ'),
            centerTitle: true,
          ),
          body: Consumer<SearchViewModel>(builder: (context, vm, child) {
            return Column(
              children: [
                Expanded(
                    child: vm.suggestions.isEmpty
                        ? GestureDetector(
                            child: Container(
                              color: Colors.transparent,
                            ),
                            onTap: () {
                              FocusScope.of(context).unfocus();
                            })
                        : _buildSuggestionList(vm)),
                SearchBar(
                  onSubmitted: (searchWord) {
                    vm.openSearchResult(context, searchWord);
                  },
                  onTextChanged: (text) => onTextChanged(context, text),
                ),
              ],
            );
          })),
    );
  }

  Widget _buildSuggestionList(SearchViewModel vm) {
    return ListView.separated(
      itemCount: vm.suggestions.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: ListTile(
              title: Text(
                vm.suggestions[index].word,
                style: TextStyle(fontSize: 20),
              ),
              leading: Icon(Icons.search)),
          onTap: () {
            vm.openSearchResult(context, vm.suggestions[index].word);
          },
        );
      },
      separatorBuilder: (context, index) => Divider(),
    );
  }

  void onTextChanged(BuildContext context, String filterWord) async {
    final vm = Provider.of<SearchViewModel>(context, listen: false);
    filterWord = filterWord.trim();
    filterWord.isEmpty
        ? vm.clearSuggestions()
        : await vm.getSuggestions(filterWord);
  }
}
