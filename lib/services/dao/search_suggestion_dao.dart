import 'package:tipitaka_pali/business_logic/models/search_suggestion.dart';
import 'package:tipitaka_pali/services/dao/dao.dart';

class SearchSuggestionDao implements Dao<SearchSuggestion> {
  final String tableWords = 'words';
  final String columnWord = 'word';
  @override
  List<SearchSuggestion> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }

  @override
  SearchSuggestion fromMap(Map<String, dynamic> query) {
    return SearchSuggestion(query[columnWord]);
  }

  @override
  Map<String, dynamic> toMap(SearchSuggestion object) {
    throw UnimplementedError();
  }
}
