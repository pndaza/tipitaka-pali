import 'package:tipitaka_pali/business_logic/models/page_content.dart';
import 'package:tipitaka_pali/services/dao/page_content_dao.dart';
import 'package:tipitaka_pali/services/database/database_helper.dart';

abstract class PageContentRepository {
  Future<List<PageContent>> getPages(String bookID);
  Future<PageContent> getPage(int id);
}

class PageContentDatabaseRepository implements PageContentRepository {
  final dao = PageContentDao();
  final DatabaseHelper databaseProvider;
  PageContentDatabaseRepository(this.databaseProvider);

  @override
  Future<List<PageContent>> getPages(String bookID) async {
    final db = await databaseProvider.database;
    List<Map<String, dynamic>> maps = await db.query(dao.tableName,
        columns: [
          dao.columnPage,
          dao.columnContent,
        ],
        where: '${dao.columnBookID} = ?',
        whereArgs: [bookID]);
    return dao.fromList(maps);
  }

  @override
  Future<PageContent> getPage(int id) async {
    final db = await databaseProvider.database;
    List<Map<String, dynamic>> maps = await db.query(dao.tableName,
        columns: [
          dao.columnPage,
          dao.columnContent,
        ],
        where: '${dao.columnID} = ?',
        whereArgs: [id]);
    return dao.fromMap(maps.first);
  }
}
