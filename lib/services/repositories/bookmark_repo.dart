import 'package:tipitaka_pali/business_logic/models/bookmark.dart';
import 'package:tipitaka_pali/services/dao/bookmark_dao.dart';
import 'package:tipitaka_pali/services/database/database_provider.dart';

abstract class BookmarkRepository {
  late DatabaseProvider databaseProvider;

  Future<int> insert(Bookmark bookmark);

  Future<int> delete(Bookmark bookmark);

  Future<int> deleteAll();

  Future<List<Bookmark>> getBookmarks();
}

class BookmarkDatabaseRepository extends BookmarkRepository {
  final dao = BookmarkDao();

  @override
  DatabaseProvider databaseProvider;

  BookmarkDatabaseRepository(this.databaseProvider);

  @override
  Future<int> insert(Bookmark bookmark) async {
    final db = await databaseProvider.database;
    return await db.insert(dao.tableBookmark, dao.toMap(bookmark));
  }

  @override
  Future<int> delete(Bookmark bookmark) async {
    final db = await databaseProvider.database;
    return await db.delete(dao.tableBookmark,
        where: '${dao.columnBookId} = ?', whereArgs: [bookmark.bookID]);
  }

  @override
  Future<int> deleteAll() async {
    final db = await databaseProvider.database;
    return await db.delete(dao.tableBookmark);
  }

  @override
  Future<List<Bookmark>> getBookmarks() async {
    final db = await databaseProvider.database;
    var maps = await db.rawQuery('''
      SELECT ${dao.columnBookId}, ${dao.columnPageNumber}, ${dao.columnNote}, ${dao.columnName}
      FROM ${dao.tableBookmark}
      INNER JOIN ${dao.tableBooks} ON ${dao.tableBooks}.${dao.columnID} = ${dao.tableBookmark}.${dao.columnBookId}
      ''');
    return dao.fromList(maps);
  }
}
