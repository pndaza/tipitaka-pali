import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../../business_logic/view_models/search_page_view_model.dart';
import '../widgets/search_bar.dart';
import 'search_mode_view.dart';
import 'suggestion_list_tile.dart';

enum QueryMode { exact, distance, prefix }

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final TextEditingController controller;
  late QueryMode queryMode;
  late bool isShowingSearchModeView;

  @override
  void initState() {
    controller = TextEditingController();
    queryMode = QueryMode.exact;
    isShowingSearchModeView = false;
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
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.search),
                centerTitle: true,
              ),
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
                                  final selectedWord =
                                      vm.suggestions[index].word;

                                  final words = inputText.split(' ');
                                  words.last = selectedWord;
                                  vm.onSubmmited(
                                      context, words.join(' '), queryMode);
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
                              vm.onSubmmited(context, searchWord, queryMode),
                          onTextChanged: vm.onTextChanged,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () {
                          setState(() {
                            isShowingSearchModeView = !isShowingSearchModeView;
                          });
                        },
                      ),
                    ],
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    child: isShowingSearchModeView
                        ? SearchModeView(
                            mode: queryMode,
                            onChanged: (value) {
                              queryMode = value;
                            },
                          )
                        : const SizedBox(height: 0),
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

  // _showSearchTypeSelectDialog(QueryMode queryMode) {
  //   return showBottomSheet<void>(
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return SearchModeView(mode: queryMode);
  //       });
  // }
}
