import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../business_logic/view_models/search_page_view_model.dart';
import '../../../services/provider/script_language_provider.dart';
import '../../../utils/pali_script.dart';
import '../../../utils/script_detector.dart';
import 'widgets/search_bar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchViewModel>(
      create: (_) => SearchViewModel(),
      child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.search),
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
                    final inputScriptLanguage =
                        ScriptDetector.getLanguage(searchWord);
                    if (inputScriptLanguage != 'Roman') {
                      searchWord = PaliScript.getRomanScriptFrom(
                          language: inputScriptLanguage, text: searchWord);
                    }

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
        final suggestion = vm.suggestions[index];


        return ListTile(
          dense: true,
          minVerticalPadding: 0,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          title: Text(
            PaliScript.getScriptOf(
                language:
                    context.read<ScriptLanguageProvider>().currentLanguage,
                romanText: suggestion.word),
            style: const TextStyle(fontSize: 20),
          ),
          leading: const Icon(Icons.search),
          trailing: Text(
            PaliScript.getScriptOf(
                language:
                    context.read<ScriptLanguageProvider>().currentLanguage,
                romanText: suggestion.count.toString()),
            style: const TextStyle(fontSize: 18)),
          onTap: () {
            vm.openSearchResult(context, vm.suggestions[index].word);
          },
        );
      },
      separatorBuilder: (context, index) => const Divider(
        height: 1,
      ),
    );
  }

  void onTextChanged(BuildContext context, String filterWord) async {
    final vm = Provider.of<SearchViewModel>(context, listen: false);
    filterWord = filterWord.trim();
    if (filterWord.isEmpty) vm.clearSuggestions();
    // loading suggested words
    final inputScriptLanguage = ScriptDetector.getLanguage(filterWord);
    if (inputScriptLanguage != 'Roman') {
      filterWord = PaliScript.getRomanScriptFrom(
          language: inputScriptLanguage, text: filterWord);
    }
    await vm.getSuggestions(filterWord);
  }
}
