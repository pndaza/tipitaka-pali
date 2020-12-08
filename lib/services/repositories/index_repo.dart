import 'package:tipitaka_pali/business_logic/models/index.dart';
import 'package:tipitaka_pali/services/dao/index_dao.dart';
import 'package:tipitaka_pali/services/database/database_provider.dart';

abstract class IndexRepository {
  Future<List<Index>> getIndexes(String word);
}

class IndexDatabaseRepository implements IndexRepository {
  final dao = IndexDao();
  final DatabaseProvider databaseProvider;

  IndexDatabaseRepository(this.databaseProvider);

  @override
  Future<List<Index>> getIndexes(String word) async {
    final db = await databaseProvider.database;
    var results = await db.query(dao.tableWords,
        columns: [dao.columnIndex],
        where: '${dao.columnWord} = ?',
        whereArgs: [word]);
    return results.isNotEmpty ? dao.fromList(results) : <Index>[];
  }
}
