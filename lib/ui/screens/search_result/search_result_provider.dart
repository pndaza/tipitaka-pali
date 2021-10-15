import 'package:flutter/material.dart';
import 'package:tipitaka_pali/ui/screens/home/search_page.dart';

import '../../../business_logic/models/search_result.dart';
import '../../../routes.dart';
import '../../../services/search_service.dart';
import 'search_filter_provider.dart';
import 'search_result_state.dart';

class SearchResultController extends ChangeNotifier {
  SearchResultController(
      {required this.searchWord,required this.queryMode ,required this.filterController});
  final String searchWord;
  final QueryMode queryMode;
  final SearchFilterController filterController;
  // final SearchFilterNotifier searchFilterNotifier;
  List<SearchResult> _allResults = [];
  List<SearchResult> _filterdResults = [];
  SearchResultState _state = const SearchResultState.loading();
  SearchResultState get state => _state;

  void init() async {
    _allResults = await SearchService.getResultsByFTS(searchWord.toLowerCase(), queryMode);
    if (_allResults.isEmpty) {
      _state = const SearchResultState.noData();
      notifyListeners();
      return;
    }
    // filtering results
    _filterdResults = _doFilter(filterController);
    // updating state
    _state = SearchResultState.loaded(_filterdResults, getBookCount());
    notifyListeners();
  }

  void onChangeFilter(SearchFilterController filterController) {
    // change state to loading while filtering
    _state = const SearchResultState.loading();
    notifyListeners();
    // filtering
    _filterdResults = _doFilter(filterController);
    // update state
    _state = SearchResultState.loaded(_filterdResults, getBookCount());
    notifyListeners();
  }

  List<SearchResult> _doFilter(SearchFilterController filterController) {
    final selectedMainCategoryFilters =
        filterController.selectedMainCategoryFilters;
    final selectedSubCategoryFilters =
        filterController.selectedSubCategoryFilters;

    final List<SearchResult> firstFilterdList = [];
    final List<SearchResult> secondFilterdList = [];

    // book id strcture : mula_vi_01 , attha_di_01 etc
    // first part of id is main category [mual, athha, tika, annya]
    // middle part is sub catergory [vi, di, ma etc]

    // do filter with main category
    for (var element in selectedMainCategoryFilters) {
      firstFilterdList.addAll(_allResults.where((searchResult) {
        return searchResult.book.id.contains(element);
      }).toList());
    }

    // do filter with sub scategory
    for (var element in selectedSubCategoryFilters) {
      secondFilterdList.addAll(firstFilterdList
          .where((searchResult) => searchResult.book.id.contains(element))
          .toList());
    }
    // book order was changed while filtering
    // so need to reorder
    secondFilterdList.sort((a, b) => a.id.compareTo(b.id));
    return secondFilterdList;
  }

  int getBookCount() {
    final books = <String>{};
    for (var element in _filterdResults) {
      books.add(element.book.id);
    }
    return books.length;
  }

  void openBook(SearchResult result, BuildContext context) {
    Navigator.pushNamed(context, readerRoute, arguments: {
      'book': result.book,
      'currentPage': result.pageNumber,
      'textToHighlight': searchWord
    });
  }
}
