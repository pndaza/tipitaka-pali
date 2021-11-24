import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tipitaka_pali/data/constants.dart';
import 'package:tipitaka_pali/services/database/database_helper.dart';
import 'package:tipitaka_pali/services/prefs.dart';

class InitialSetupViewModel extends ChangeNotifier {
  final BuildContext _context;
  String _indexStatus = '';
  void updateMessageCallback(String msg) {
    _indexStatus = msg;
    notifyListeners();
  }

  InitialSetupViewModel(this._context);
  String get indexStatus => _indexStatus;

  Future<void> setUp(bool isUpdateMode) async {
    debugPrint('isUpdateMode : $isUpdateMode');

    late String databasesDirPath;

    if (Platform.isAndroid || Platform.isIOS || Platform.isMacOS) {
      databasesDirPath = await getDatabasesPath();
    }
    if (Platform.isLinux || Platform.isWindows) {
      final docDirPath = await getApplicationDocumentsDirectory();
      databasesDirPath = docDirPath.path;
    }
    // final databasesDirPath = await getApplicationDocumentsDirectory();
    final dbFilePath = join(databasesDirPath, DatabaseInfo.fileName);

    final recents = <Map<String, Object?>>[];
    final bookmarks = <Map<String, Object?>>[];
    final dictionaries = <Map<String, Object?>>[];

    if (isUpdateMode) {
      // backuping user data to memory
      final DatabaseHelper databaseHelper = DatabaseHelper();
      recents.addAll(await databaseHelper.backup(tableName: 'recent'));
      bookmarks.addAll(await databaseHelper.backup(tableName: 'bookmark'));
      dictionaries
          .addAll(await databaseHelper.backup(tableName: 'dictionary_books'));

      debugPrint('dictionary books: ${dictionaries.length}');
      await databaseHelper.close();
      // deleting old database file
      await deleteDatabase(dbFilePath);
    }

    //Check if parent directory exists
    try {
      await Directory(dirname(databasesDirPath)).create(recursive: true);
    } catch (_) {}

    // copying new database from assets
    await _copyFromAssets(dbFilePath);

    final DatabaseHelper databaseHelper = DatabaseHelper();
    // restoring user data
    if (recents.isNotEmpty) {
      await databaseHelper.restore(tableName: 'recent', values: recents);
    }

    if (bookmarks.isNotEmpty) {
      await databaseHelper.restore(tableName: 'bookmark', values: bookmarks);
    }

    // dictionary_books table is semi-user data
    // need to delete before restoring
    if (dictionaries.isNotEmpty) {
      await databaseHelper.deleteDictionaryData();
      debugPrint('dictionary books: ${dictionaries.length}');
      await databaseHelper.restore(
          tableName: 'dictionary_books', values: dictionaries);
    }

    // save record to shared Preference
    Prefs.isDatabaseSaved = true;
    Prefs.databaseVersion = DatabaseInfo.version;

    _openHomePage();
  }

  Future<void> _copyFromAssets(String dbFilePath) async {
    final assetsDatabasePath = join(
      AssetsFile.baseAssetsFolderPath,
      AssetsFile.databaseFolderPath,
    );

    final dbFile = File(dbFilePath);
    final timeBeforeCopy = DateTime.now();
    for (String part in AssetsFile.partsOfDatabase) {
      // reading from assets
      final bytes = await rootBundle.load(join(assetsDatabasePath, part));
      // appending to output dbfile
      await dbFile.writeAsBytes(
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
          mode: FileMode.append);
    }

    final timeAfterCopied = DateTime.now();
    debugPrint(
        'database copying time: ${timeAfterCopied.difference(timeBeforeCopy)}');

    // final isDbExist = await databaseExists(dbFilePath);
    // debugPrint('is db exist: $isDbExist');

    final timeBeforeIndexing = DateTime.now();

    // creating index tables

    final DatabaseHelper databaseHelper = DatabaseHelper();

    final indexResult = await databaseHelper.buildIndex();
    if (indexResult == false) {
      // handle error
    }

    // creating fts table
    final ftsResult = await DatabaseHelper().buildFts(updateMessageCallback);
    if (ftsResult == false) {
      // handle error
    }

    final timeAfterIndexing = DateTime.now();
    //_indexStatus =help
    notifyListeners();

    debugPrint(
        'indexing time: ${timeAfterIndexing.difference(timeBeforeIndexing)}');
  }

  void _openHomePage() {
    Navigator.of(_context).popAndPushNamed('/home');
  }
}
