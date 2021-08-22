import 'package:tipitaka_pali/business_logic/models/Definition.dart';
import 'package:tipitaka_pali/services/dao/dict_dao.dart';
import 'package:tipitaka_pali/services/database/database_provider.dart';

abstract class DictionaryRepository {
  Future<List<Definition>> getDefinition(String id);
}

class DictionaryDatabaseRepository implements DictionaryRepository {
  final dao = DictionaryDao();
  final DatabaseProvider databaseProvider;
  DictionaryDatabaseRepository(this.databaseProvider);

  @override
  Future<List<Definition>> getDefinition(String word) async {
    final db = await databaseProvider.database;
    List<Map<String, dynamic>> maps = await db.query(dao.tableDict,
        columns: [dao.columnDefinition, dao.colunmnBook],
        where: '${dao.columnWord} = ?',
        whereArgs: [word]);
    return dao.fromList(maps);
  }
}
