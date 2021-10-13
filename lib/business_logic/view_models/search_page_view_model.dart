import 'package:flutter/material.dart';
import 'package:tipitaka_pali/utils/pali_script.dart';
import 'package:tipitaka_pali/utils/script_detector.dart';

import '../../routes.dart';
import '../../services/search_service.dart';
import '../models/search_suggestion.dart';

class SearchPageViewModel extends ChangeNotifier {
  final List<SearchSuggestion> _suggestions = [];
  List<SearchSuggestion> get suggestions => _suggestions;

  bool isSearching = false;
  // String _searchWord = '';

  // String get searchWord => _searchWord;

  Future<void> onTextChanged(String filterWord) async {
    filterWord = filterWord.trim();
    if (filterWord.isEmpty) {
      suggestions.clear();
      notifyListeners();
      return;
    }
    // loading suggested words
    final inputScriptLanguage = ScriptDetector.getLanguage(filterWord);
    if (inputScriptLanguage != 'Roman') {
      filterWord = PaliScript.getRomanScriptFrom(
          language: inputScriptLanguage, text: filterWord);
    }

    final words = filterWord.split(' ');
    _suggestions.clear();
    _suggestions.addAll(await SearchService.getSuggestions(words.last));
    notifyListeners();
  }

  Future<void> clearSuggestions() async {
    suggestions.clear();
    notifyListeners();
  }

  void onSubmmited(BuildContext context, String searchWord) {
    final inputScriptLanguage = ScriptDetector.getLanguage(searchWord);
    if (inputScriptLanguage != 'Roman') {
      searchWord = PaliScript.getRomanScriptFrom(
          language: inputScriptLanguage, text: searchWord);
    }

    Navigator.pushNamed(context, searchResultRoute, arguments: {
      'searchWord': searchWord,
    });
  }

  // void openBook(SearchResult result, BuildContext context) {
  //   Navigator.pushNamed(context, readerRoute, arguments: {
  //     'book': result.book,
  //     'currentPage': result.pageNumber,
  //     'textToHighlight': _searchWord
  //   });
  // }
}
