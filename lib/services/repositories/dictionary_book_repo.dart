import 'package:tipitaka_pali/business_logic/models/dictionary.dart';
import 'package:tipitaka_pali/services/dao/dictionary_book_dao.dart';
import 'package:tipitaka_pali/services/database/database_helper.dart';

abstract class UserDictRepository {
  late DatabaseHelper databaseProvider;

  Future<void> updateDall(List<Dictionary> userDicts);
  Future<void> update(Dictionary dictionary);

  Future<List<Dictionary>> getUserDicts();
}

class UserDictDatabaseRepository implements UserDictRepository {
  final dao = DictionaryBookDao();
  @override
  DatabaseHelper databaseProvider;

  UserDictDatabaseRepository(this.databaseProvider);

  @override
  Future<List<Dictionary>> getUserDicts() async {
    final db = await databaseProvider.database;
    List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT * FROM ${dao.tableUserDict} ORDER BY ${dao.columnOrder} ASC
      ''');
    return dao.fromList(maps).toList();
  }

  @override
  Future<void> updateDall(List<Dictionary> userDicts) async {
    //
    final db = await databaseProvider.database;
    // delect previous records
    int count = await db.delete(dao.tableUserDict);
    //print('delete items: $count');
    // insert new records
    for (final userDict in userDicts) {
      //print(userDict.name);
      var id = await db.insert(dao.tableUserDict, dao.toMap(userDict));
      //print('insert id: $id');
    }
  }

  @override
  Future<void> update(Dictionary dictionary) async {
    final db = await databaseProvider.database;
    db.update(dao.tableUserDict, dao.toMap(dictionary),
        where: '${dao.columnBookId} = ?', whereArgs: [dictionary.bookID]);
  }
}
