import 'package:flutter/material.dart';
import 'package:tipitaka_pali/business_logic/models/index.dart';
import 'package:tipitaka_pali/business_logic/models/search_result.dart';
import 'package:tipitaka_pali/services/search_provider.dart';

import '../../routes.dart';

class SearchResultNotifier extends ChangeNotifier {
  final String searchWord;
  List<Index> _allIndexList = [];
  // List<Index> _filterIndexList = [];
  List<Index> get indexList =>   _allIndexList;


  SearchResultNotifier(this.searchWord) {
    _init();
  }

  void _init() async {
    _allIndexList = await SearchProvider.getResults(searchWord);
    notifyListeners();
  }

  Future<List<Index>> getResults() async {
    _allIndexList = await SearchProvider.getResults(searchWord);
    // print('from SearchProvider.getResults: ${_allIndexList.length}');
    return _allIndexList;
  }

  Future<SearchResult> getDetailResult(Index index) async {
    return await SearchProvider.getDetail(searchWord, index);
  }

  void openBook(SearchResult result, BuildContext context) {
    Navigator.pushNamed(context, ReaderRoute, arguments: {
      'book': result.book,
      'currentPage': result.pageNumber,
      'textToHighlight': searchWord
    });
  }
}
