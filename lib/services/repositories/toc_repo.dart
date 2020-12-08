import 'package:tipitaka_pali/business_logic/models/toc.dart';
import 'package:tipitaka_pali/services/dao/toc_dao.dart';
import 'package:tipitaka_pali/services/database/database_provider.dart';

abstract class TocRepository {
  Future<List<Toc>> getTocs(String bookID);
}

class TocDatabaseRepository implements TocRepository {
  final dao = TocDao();
  final DatabaseProvider databaseProvider;

  TocDatabaseRepository(this.databaseProvider);

  @override
  Future<List<Toc>> getTocs(String bookID) async {
    final db = await databaseProvider.database;
    var results = await db.query(dao.tableName,
        columns: [dao.columnName, dao.columnType, dao.columnPageNumber],
        where: '${dao.columnBookID} = ?',
        whereArgs: [bookID]);
    return dao.fromList(results);
  }
}
