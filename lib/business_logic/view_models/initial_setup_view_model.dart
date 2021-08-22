import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tipitaka_pali/app.dart';
import 'package:tipitaka_pali/data/constants.dart';
import 'package:tipitaka_pali/utils/shared_preferences_provider.dart';

class InitialSetupViewModel extends ChangeNotifier {
  final BuildContext _context;
  final String _assetsFolder = 'assets';
  final String _databasePath = 'database';
  final String archiveFile = 'books.zip';
  InitialSetupViewModel(this._context);

  Future<void> setUp(bool isUpdateMode) async {
    myLogger.i('isUpdateMode : $isUpdateMode');
    final databasesPath = await getDatabasesPath();
    final tempDir = await getTemporaryDirectory();
    final tempDirPath = tempDir.path;

    if (isUpdateMode) {
      await _deleteFile(join(databasesPath, k_databaseName));
    }
    var sourceDbArchive = join(_assetsFolder, _databasePath, k_assetsDatabaseArchive);
    var tempDbArchive = join(tempDirPath, k_assetsDatabaseArchive);
    await _copyFromAssets(sourceDbArchive, tempDbArchive);
    await _nativeExtract(tempDbArchive, databasesPath);
    await _deleteFile(tempDbArchive);

    // save record to sharedpref
    await SharedPrefProvider.setBool(key: k_key_isDatabaseSaved, value: true);
    await SharedPrefProvider.setInt(
        key: k_key_databaseVersion, value: k_currentDatabaseVersion);

    _openHomePage();
  }

  Future<void> _copyFromAssets(String source, String destionation) async {
    myLogger.i('coping from assets');
    ByteData data = await rootBundle.load(source);
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(destionation).writeAsBytes(bytes, flush: true);
    if (await File(destionation).exists()) {
      myLogger.i('dbArchive is copied to $destionation');
    }
  }

  Future<void> _nativeExtract(
      String zipFilePath, String destionationDir) async {
    myLogger.i('extracting zip');
    final zipFile = File(zipFilePath);
    final destinationDir = Directory(destionationDir);

    await ZipFile.extractToDirectory(
        zipFile: zipFile,
        destinationDir: destinationDir,
        onExtracting: (zipEntry, progress) {
          myLogger.i('progress: ${progress.toStringAsFixed(1)}%');
          myLogger.i('name: ${zipEntry.name}');
          return ZipFileOperation.includeItem;
        });
  }

  // Future<void> _extract(String zipFilePath, String destionationDir) async {
  //   // Decode the Zip file
  //   // Read the Zip file from disk.
  // final bytes = File(zipFilePath).readAsBytesSync();
  // final archive = ZipDecoder().decodeBytes(bytes);

  // // Extract the contents of the Zip archive to disk.
  // for (final file in archive) {
  //   final filename = file.name;
  //   if (file.isFile) {
  //     final data = file.content as List<int>;
  //     File(join(destionationDir, filename))
  //       ..createSync(recursive: true)
  //       ..writeAsBytesSync(data);
  //   } else {
  //     Directory(join(destionationDir, filename))
  //       ..create(recursive: true);
  //   }
  // }
  // }

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
