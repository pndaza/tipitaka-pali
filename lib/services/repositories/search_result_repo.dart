import 'package:tipitaka_pali/business_logic/models/index.dart';
import 'package:tipitaka_pali/business_logic/models/page_content.dart';
import 'package:tipitaka_pali/business_logic/models/search_result.dart';
import 'package:tipitaka_pali/services/dao/search_result_dao.dart';
import 'package:tipitaka_pali/services/database/database_helper.dart';

abstract class SearchResultRepository {
  Future<PageContent> getPageContent(int pageID);
  Future<SearchResult> getDetail(Index index);
}

class SearchResultDatabaseRepository implements SearchResultRepository {
  final dao = SearchResultDao();
  final DatabaseHelper databaseProvider;
  SearchResultDatabaseRepository(this.databaseProvider);

  @override
  Future<PageContent> getPageContent(int pageID) async {
    final db = await databaseProvider.database;
    List<Map<String, dynamic>> maps = await db.query(dao.tablePages,
        columns: [dao.columnBookID, dao.columnPage, dao.columnContent],
        where: "${dao.columnID} = ?",
        whereArgs: [pageID]);
    return dao.fromMap(maps.first);
  }

  @override
  Future<SearchResult> getDetail(Index index) {
    // TODO: implement getDetail
    throw UnimplementedError();
  }
}
