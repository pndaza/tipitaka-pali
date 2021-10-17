import 'package:backdrop/app_bar.dart';
import 'package:backdrop/button.dart';
import 'package:backdrop/scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../business_logic/view_models/search_page_view_model.dart';
import '../../../services/provider/script_language_provider.dart';
import '../../../utils/pali_script.dart';
import 'widgets/search_bar.dart';

enum QueryMode { exact, distance, prefix }

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchPageViewModel>(
        create: (_) => SearchPageViewModel(),
        child: Consumer<SearchPageViewModel>(builder: (context, vm, child) {
          return Scaffold(
              body: Column(
            children: [
              // suggestion view
              Expanded(
                  child: vm.suggestions.isEmpty
                      ? _buildEmptyView(context)
                      : ListView.separated(
                          itemCount: vm.suggestions.length,
                          itemBuilder: (_, index) => SuggestionListTile(
                            suggestedWord: vm.suggestions[index].word,
                            frequency: vm.suggestions[index].count,
                            isFirstWord: vm.isFirstWord,
                            onTap: () {
                              //
                              final inputText = controller.text;
                              final selectedWord = vm.suggestions[index].word;

                              final words = inputText.split(' ');
                              words.last = selectedWord;
                              vm.onSubmmited(context, words.join(' '));
                            },
                          ),
                          separatorBuilder: (_, __) => const Divider(
                            height: 1,
                          ),
                        )),
              Row(
                children: [
                  Expanded(
                    child: SearchBar(
                      controller: controller,
                      onSubmitted: (searchWord) =>
                          vm.onSubmmited(context, searchWord),
                      onTextChanged: vm.onTextChanged,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        _showSearchTypeSelectDialog(context);
                      },
                      icon: const Icon(Icons.more_vert)),
                ],
              ),
            ],
          ));
        }));
  }

  Widget _buildEmptyView(BuildContext context) {
    return GestureDetector(
      child: Container(color: Colors.transparent),
      // in android, keyboard can be hide by pressing back button
      // ios doesn't have back button
      // so to hide keyboard, provide this
      onTap: () => FocusScope.of(context).unfocus(),
    );
  }

  _showSearchTypeSelectDialog(BuildContext context) {
    final vm = context.watch<SearchPageViewModel>();
    return showBottomSheet<void>(
        context: context,
        builder: (BuildContext bc) {
          return SearchModeView(mode: vm.queryMode);
        });
  }
}

class SuggestionListTile extends StatelessWidget {
  const SuggestionListTile({
    Key? key,
    required this.suggestedWord,
    required this.frequency,
    this.isFirstWord = true,
    this.onTap,
  }) : super(key: key);
  final String suggestedWord;
  final int frequency;
  final bool isFirstWord;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    String scriptWord = PaliScript.getScriptOf(
        language: context.read<ScriptLanguageProvider>().currentLanguage,
        romanText: suggestedWord);
    if (!isFirstWord) {
      scriptWord = '... $scriptWord';
    }
    return ListTile(
      dense: true,
      minVerticalPadding: 0,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      // suggested word
      title: Text(scriptWord, style: const TextStyle(fontSize: 20)),
      leading: const Icon(Icons.search),
      // word frequency
      trailing: Text(
          PaliScript.getScriptOf(
              language: context.read<ScriptLanguageProvider>().currentLanguage,
              romanText: frequency.toString()),
          style: const TextStyle(fontSize: 18)),
      onTap: onTap,
    );
  }
}

class SearchModeView extends StatelessWidget {
  const SearchModeView({Key? key, required this.mode}) : super(key: key);
  final QueryMode mode;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary.withAlpha(220),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<QueryMode>(
              title: const Text('Exact'),
              value: QueryMode.exact,
              groupValue: mode,
              onChanged: (value) {
                context.read<SearchPageViewModel>().onQueryModeChange(value);
              }),
          RadioListTile<QueryMode>(
              title: const Text('Prefix'),
              value: QueryMode.prefix,
              groupValue: mode,
              onChanged: (value) {
                context.read<SearchPageViewModel>().onQueryModeChange(value);
              }),
          RadioListTile<QueryMode>(
              title: const Text('Distance'),
              value: QueryMode.distance,
              groupValue: mode,
              onChanged: (value) {
                context.read<SearchPageViewModel>().onQueryModeChange(value);
              }),
        ],
      ),
    );
  }
}
