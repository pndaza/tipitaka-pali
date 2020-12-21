import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tipitaka_pali/app.dart';
import 'package:tipitaka_pali/data/constants.dart';
import 'package:tipitaka_pali/utils/shared_preferences_provider.dart';

class InitialSetupViewModel extends ChangeNotifier {
  final BuildContext _context;
  final String _assetsFolder = 'assets';
  final String _databasePath = 'database';
  InitialSetupViewModel(this._context);

  Future<void> setUp(bool isUpdateMode) async {
    myLogger.i('isUpdateMode : $isUpdateMode');
    final databasesPath = await getDatabasesPath();
    var savePath = join(databasesPath , k_databaseName);
    if (isUpdateMode) {
      _deleteFile(savePath);
    }
    await _copy(savePath);

    // save record to sharedpref
    await SharedPrefProvider.setBool(key: k_key_isDatabaseSaved, value: true);
    await SharedPrefProvider.setInt(
        key: k_key_databaseVersion, value: k_currentDatabaseVersion);

    _openHomePage();
  }

  Future<void> _copy(String savePath) async {
    ByteData data = await rootBundle
        .load(join(_assetsFolder, _databasePath, k_databaseName));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(savePath).writeAsBytes(bytes, flush: true);
  }

  Future<void> _deleteFile(String path) async {
    var file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  void _openHomePage() {
    Navigator.of(_context).popAndPushNamed('/home');
  }
}
