import 'package:flutter/material.dart';
import 'package:tipitaka_pali/ui/screens/home/search_page.dart';
import 'package:tipitaka_pali/utils/pali_script.dart';
import 'package:tipitaka_pali/utils/script_detector.dart';

import '../../routes.dart';
import '../../services/search_service.dart';
import '../models/search_suggestion.dart';

class SearchPageViewModel extends ChangeNotifier {
  final List<SearchSuggestion> _suggestions = [];
  List<SearchSuggestion> get suggestions => _suggestions;

  QueryMode _queryMode = QueryMode.exact;
  QueryMode get queryMode => _queryMode;

  bool isSearching = false;
  bool _isFirstWord = true;
  bool get isFirstWord => _isFirstWord;

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
    if (words.length == 1) {
      _isFirstWord = true;
    } else {
      _isFirstWord = false;
    }
    // print('is first word: $_isFirstWord');
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

    Navigator.pushNamed(context, searchResultRoute,
        arguments: {'searchWord': searchWord, 'queryMode': _queryMode});
  }

  void onQueryModeChange(QueryMode? queryMode) {
    if (queryMode != null) {
      _queryMode = queryMode;
      notifyListeners();
    }
  }
}
