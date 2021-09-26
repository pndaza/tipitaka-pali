import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

import '../../../business_logic/view_models/search_page_view_model.dart';
import '../../dialogs/dictionary_dialog.dart';
import 'widgets/search_bar.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchViewModel>(
      create: (_) => SearchViewModel(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.search),
            centerTitle: true,
            actions: [
              TextButton.icon(
                  onPressed: () => _showDictionaryDialog(context),
                  icon: Icon(Icons.search, color: Colors.white),
                  label: Text('Dict', style: TextStyle(color: Colors.white))),
            ],
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
        return ListTile(
          dense: true,
          minVerticalPadding: 0,
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          title: Text(
            vm.suggestions[index].word,
            style: TextStyle(fontSize: 20),
          ),
          leading: Icon(Icons.search),
          onTap: () {
            vm.openSearchResult(context, vm.suggestions[index].word);
          },
        );
      },
      separatorBuilder: (context, index) => Divider(
        height: 1,
      ),
    );
  }

  void onTextChanged(BuildContext context, String filterWord) async {
    final vm = Provider.of<SearchViewModel>(context, listen: false);
    filterWord = filterWord.trim();
    filterWord.isEmpty
        ? vm.clearSuggestions()
        : await vm.getSuggestions(filterWord);
  }

  Future<void> _showDictionaryDialog(BuildContext context) async {
    // removing puntuations etc.

    await showSlidingBottomSheet(context, builder: (context) {
      //Widget for SlidingSheetDialog's builder method
      final statusBarHeight = MediaQuery.of(context).padding.top;
      final screenHeight = MediaQuery.of(context).size.height;
      final marginTop = 24.0;
      final slidingSheetDialogContent = Container(
        height: screenHeight - (statusBarHeight + marginTop),
        child: DictionaryDialog(),
      );

      return SlidingSheetDialog(
        elevation: 8,
        cornerRadius: 16,
        // minHeight: 200,
        snapSpec: const SnapSpec(
          snap: true,
          snappings: [0.4, 0.6, 0.8, 1.0],
          positioning: SnapPositioning.relativeToSheetHeight,
        ),
        headerBuilder: (context, _) {
          // building drag handle view
          return Center(
              heightFactor: 1,
              child: Container(
                width: 56,
                height: 10,
                // color: Colors.black45,
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.red),
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ));
        },
        // this builder is called when state change
        // normaly three states occurs
        // first state - isLaidOut = false
        // second state - islaidOut = true , isShown = false
        // thirs state - islaidOut = true , isShown = ture
        // to avoid there times rebuilding, return  prebuild content
        builder: (context, state) => slidingSheetDialogContent,
      );
    });
  }
}
