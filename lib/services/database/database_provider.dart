import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  // static final String _assetsFolder = 'assets';
  // static final String _databasePath = 'database';
  static final String _databaseName = 'tipitaka_pali.db';
  // static final int _currentDatabaseVersion = 2;

  DatabaseProvider._internal();
  static final DatabaseProvider _instance = DatabaseProvider._internal();
  factory DatabaseProvider() => _instance;

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

// Open Assets Database
  _initDatabase() async {
    print('initializing Database');
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, _databaseName);

    // var exists = await databaseExists(path);

    // if (exists) {
    //   var savedDatabaseVersion = await SharedPrefProvider.getInt(
    //       key: SharedPrefProvider.key_db_version);
    //   if (savedDatabaseVersion == _currentDatabaseVersion) {
    //     print('opening Exiting Database ...');
    //     return await openDatabase(path);
    //   } else {
    //     // deleting old database
    //     print('deleting old databse');
    //     await File(path).delete();
    //   }
    // }

    // print('creating new copy from asset');
    // try {
    //   await Directory(dirname(path)).create(recursive: true);
    // } catch (_) {}

    // // Copy from asset
    // ByteData data = await rootBundle
    //     .load(join(_assetsFolder, _databasePath, _databaseName));
    // List<int> bytes =
    //     data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // await File(path).writeAsBytes(bytes, flush: true);
    // // building index
    // await _buildIndex(await openDatabase(path));

    // Read ONLY for dictionary
    print('opening Database ...');
    return await openDatabase(path);
  }

  Future close() async {
    return _database.close();
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
  //   await SharedPrefProvider.setInt(
  //       key: SharedPrefProvider.key_db_version, value: _currentDatabaseVersion);
  // }

  Future<bool> isDatabaseCopied() async {
    return true;
  }
}
