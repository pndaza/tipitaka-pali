import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tipitaka_pali/app.dart';
import 'package:tipitaka_pali/data/constants.dart';

class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

// Open Assets Database
  _initDatabase() async {
    myLogger.i('initializing Database');
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, k_databaseName);

    myLogger.i('opening Database ...');
    return await openDatabase(path);
  }

  Future close() async {
    return _database?.close();
  }

  // Future<void> _buildIndex(Database database) async {
  //   print('building index');
  //   await database.execute(
  //       "CREATE UNIQUE INDEX IF NOT EXISTS word_index ON words ( word )");
  //   await database
  //       .execute("CREATE INDEX IF NOT EXISTS page_index ON pages ( bookid )");
  //   await database.execute(
  //       "CREATE INDEX IF NOT EXISTS dict_index ON dictionary ( word )");
  //   database
  //       .execute("CREATE INDEX IF NOT EXISTS toc_index ON tocs ( book_id )");
  //   await database.execute(
  //       "CREATE INDEX IF NOT EXISTS paragraph_index ON paragraphs ( book_id )");

  //   // save db version
  // Prefs.databaseVerson = _currentDatabaseVersion;
  // }

  // Future<bool> isDatabaseCopied() async {
  //   return true;
  // }
}
