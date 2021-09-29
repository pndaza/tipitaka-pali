import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tipitaka_pali/app.dart';
import 'package:tipitaka_pali/data/constants.dart';
import 'package:tipitaka_pali/services/prefs.dart';

class InitialSetupViewModel extends ChangeNotifier {
  final BuildContext _context;
  InitialSetupViewModel(this._context);

  Future<void> setUp(bool isUpdateMode) async {
    myLogger.i('isUpdateMode : $isUpdateMode');
    final databasesDirPath = await getDatabasesPath();
    final dbFilePath = join(databasesDirPath, k_databaseName);

    if (isUpdateMode) {
      // deleting old database file
      await deleteDatabase(dbFilePath);
    }
    // copying new database from assets
    await _copyFromAssets(dbFilePath);

    // save record to shared Preference
    Prefs.isDatabaseSaved = true;
    Prefs.databaseVersion = k_currentDatabaseVersion;

    _openHomePage();
  }

  Future<void> _copyFromAssets(String dbFilePath) async {
    final assetsPath = join('assets', 'database');
    const parts = <String>[
      'tipitaka_pali_part.aa',
      'tipitaka_pali_part.ab',
      'tipitaka_pali_part.ac',
      'tipitaka_pali_part.ad',
      'tipitaka_pali_part.ae',
      'tipitaka_pali_part.af',
      'tipitaka_pali_part.ag',
      'tipitaka_pali_part.ah',
      'tipitaka_pali_part.ai',
      'tipitaka_pali_part.aj',
      'tipitaka_pali_part.ak',
    ];

    final dbFile = File(dbFilePath);
    final timeBeforeCopy = DateTime.now();
    for (String part in parts) {
      // reading from assets
      final bytes = await rootBundle.load(join(assetsPath, part));
      // appending to output dbfile
      await dbFile.writeAsBytes(
          bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
          mode: FileMode.append);
    }

    final timeAfterCopied = DateTime.now();
    debugPrint(
        'copying time from asset to db dir: ${timeAfterCopied.difference(timeBeforeCopy)}');

    final isDbExist = await databaseExists(dbFilePath);
    debugPrint('is db exist: $isDbExist');


    final timeBeforeIndexing = DateTime.now();

    final database = await openDatabase(dbFilePath);
    // building Index
    await database
        .execute('CREATE INDEX "dictionary_index" ON "dictionary" ("word");');
    await database
        .execute('CREATE INDEX "dpr_breakup_index" ON "dpr_breakup" ("word");');
    await database.execute('CREATE INDEX page_index ON pages ( bookid );');
    await database
        .execute('CREATE INDEX paragraph_index ON paragraphs ( book_id );');
    await database.execute(
        'CREATE INDEX paragraph_mapping_index ON paragraph_mapping ( base_page_number);');
    await database.execute('CREATE INDEX toc_index ON tocs ( book_id );');
    await database.execute('CREATE UNIQUE INDEX word_index ON words ( word );');

    final timeAfterIndexing = DateTime.now();
    debugPrint('indexing time: ${timeAfterIndexing.difference(timeBeforeIndexing)}');

  }

  void _openHomePage() {
    Navigator.of(_context).popAndPushNamed('/home');
  }
}
