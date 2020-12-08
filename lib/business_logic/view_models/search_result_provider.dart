import 'package:flutter/material.dart';
import 'package:tipitaka_pali/business_logic/models/index.dart';
import 'package:tipitaka_pali/business_logic/models/search_result.dart';
import 'package:tipitaka_pali/services/search_provider.dart';

import '../../routes.dart';

class SearchResultProvider {
  final String searchWord;
  List<Index> _indexes = [];

  SearchResultProvider(this.searchWord);

  Future<List<Index>> getResults() async {
    _indexes = await SearchProvider.getResults(searchWord);
    return _indexes;
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
