import 'package:tipitaka_pali/business_logic/models/bookmark.dart';
import 'package:tipitaka_pali/services/dao/bookmark_dao.dart';
import 'package:tipitaka_pali/services/database/database_helper.dart';

abstract class BookmarkRepository {
  Future<int> insert(Bookmark bookmark);

  Future<int> delete(Bookmark bookmark);

  Future<int> deleteAll();

  Future<List<Bookmark>> getBookmarks();
}

class BookmarkDatabaseRepository extends BookmarkRepository {
  BookmarkDatabaseRepository(this._databaseHelper, this.dao);
  final DatabaseHelper _databaseHelper;
  final BookmarkDao dao;

  @override
  Future<int> insert(Bookmark bookmark) async {
    final db = await _databaseHelper.database;
    return await db.insert(dao.tableBookmark, dao.toMap(bookmark));
  }

  @override
  Future<int> delete(Bookmark bookmark) async {
    final db = await _databaseHelper.database;
    return await db.delete(dao.tableBookmark,
        where: '${dao.columnBookId} = ?', whereArgs: [bookmark.bookID]);
  }

  @override
  Future<int> deleteAll() async {
    final db = await _databaseHelper.database;
    return await db.delete(dao.tableBookmark);
  }

  @override
  Future<List<Bookmark>> getBookmarks() async {
    final db = await _databaseHelper.database;
    var maps = await db.rawQuery('''
      SELECT ${dao.columnBookId}, ${dao.columnPageNumber}, ${dao.columnNote}, ${dao.columnName}
      FROM ${dao.tableBookmark}
      INNER JOIN ${dao.tableBooks} ON ${dao.tableBooks}.${dao.columnID} = ${dao.tableBookmark}.${dao.columnBookId}
      ''');
    return dao.fromList(maps);
  }
}
