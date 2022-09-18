import 'package:flutter/material.dart';
import 'package:tipitaka_pali/business_logic/models/dictionary_book.dart';
import 'package:tipitaka_pali/services/dao/dictionary_book_dao.dart';
import 'package:tipitaka_pali/services/database/database_helper.dart';

abstract class UserDictRepository {
  late DatabaseHelper databaseProvider;

  Future<void> updateDall(List<DictionaryBook> userDicts);
  Future<void> update(DictionaryBook dictionary);

  Future<List<DictionaryBook>> getUserDicts();
}

class UserDictDatabaseRepository implements UserDictRepository {
  final dao = DictionaryBookDao();
  @override
  DatabaseHelper databaseProvider;

  UserDictDatabaseRepository(this.databaseProvider);

  @override
  Future<List<DictionaryBook>> getUserDicts() async {
    final db = await databaseProvider.database;
    List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT * FROM ${dao.tableUserDict} ORDER BY ${dao.columnOrder} ASC
      ''');
    return dao.fromList(maps).toList();
  }

  @override
  Future<void> updateDall(List<DictionaryBook> userDicts) async {
    //
    final db = await databaseProvider.database;
    // delect previous records
    int count = await db.delete(dao.tableUserDict);
    debugPrint('delete items: $count');
    // insert new records
    for (final userDict in userDicts) {
      //print(userDict.name);
      var id = await db.insert(dao.tableUserDict, dao.toMap(userDict));
      debugPrint('insert id: $id');
    }
  }

  @override
  Future<void> update(DictionaryBook dictionary) async {
    final db = await databaseProvider.database;
    db.update(dao.tableUserDict, dao.toMap(dictionary),
        where: '${dao.columnBookId} = ?', whereArgs: [dictionary.bookID]);
  }
}
