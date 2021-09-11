import 'package:tipitaka_pali/business_logic/models/search_suggestion.dart';
import 'package:tipitaka_pali/services/dao/search_suggestion_dao.dart';
import 'package:tipitaka_pali/services/database/database_helper.dart';

abstract class SearchSuggestionRepository {
  Future<List<SearchSuggestion>> getWords(String filterWord);
}

class SearchSuggestionDatabaseRepository implements SearchSuggestionRepository {
  final dao = SearchSuggestionDao();
  final DatabaseHelper databaseProvider;
  SearchSuggestionDatabaseRepository(this.databaseProvider);

  @override
  Future<List<SearchSuggestion>> getWords(String filterWord) async {
    final db = await databaseProvider.database;
    List<Map<String, dynamic>> maps = await db.query(dao.tableWords,
        columns: [dao.columnWord],
        where: "${dao.columnWord} LIKE '$filterWord%'");
    return dao.fromList(maps);
  }
}
