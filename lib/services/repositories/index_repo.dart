import 'package:tipitaka_pali/business_logic/models/index.dart';
import 'package:tipitaka_pali/services/dao/index_dao.dart';
import 'package:tipitaka_pali/services/database/database_helper.dart';

abstract class IndexRepository {
  Future<List<Index>> getIndexes(String word);
}

class IndexDatabaseRepository implements IndexRepository {
  final dao = IndexDao();
  final DatabaseHelper databaseProvider;

  IndexDatabaseRepository(this.databaseProvider);

  @override
  Future<List<Index>> getIndexes(String word) async {
    final db = await databaseProvider.database;
    var results = await db.query(dao.tableWords,
        columns: [dao.columnIndex],
        where: '${dao.columnWord} = ?',
        whereArgs: [word]);
    List<Index> indexList = dao.fromList(results);

    if (indexList.isEmpty) return <Index>[];

    // adding bookname to index
    final int length = indexList.length;
    for (int i = 0; i < length; ++i) {
      final pageId = indexList[i].pageID;
      // final positon = indexList[i].position;

      // var map = await db.query('pages',
      //     columns: ['bookid'], where: 'id = ?', whereArgs: [pageId]);
      var map =
          await db.rawQuery('SELECT bookid FROM pages WHERE id = $pageId');
      final bookID = map[0]['bookid'] as String;
      indexList[i].bookID = bookID;
    }

    return indexList;
  }
}
