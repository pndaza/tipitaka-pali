import 'dart:io';

import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:tipitaka_pali/app.dart';
import 'package:tipitaka_pali/data/constants.dart';
import 'package:tipitaka_pali/utils/shared_preferences_provider.dart';

enum SetupState { beforeDownload, downlading, afterDownload }

class InitialSetupViewModel extends ChangeNotifier {
  final BuildContext _context;
  InitialSetupViewModel(this._context);

  SetupState _state = SetupState.beforeDownload;
  SetupState get state => _state;

  double _progress = 0;
  double get progress => _progress;

  CancelToken _cancelToken;
  Dio _dio;

  Future<void> download() async {
    _state = SetupState.downlading;
    notifyListeners();
    final urlPath =
        'https://www.dropbox.com/s/013ynfsa859tus0/tipitaka_pali.db.zip?dl=1';

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'tipitaka_pali.zip';
    final savePath = path.join(dir.path, fileName);

    _dio = Dio();
    _cancelToken = CancelToken();
    try {
      final Response response = await _dio.download(urlPath, savePath,
          onReceiveProgress: _onReceiveProgress, cancelToken: _cancelToken);
      logger.i(response.statusMessage);
    } catch (e) {
      logger.e('download canceled: $e');
      // Dio().close(force: true);
      _progress = 0;
      _state = SetupState.beforeDownload;
      notifyListeners();
      return;
    }

    _state = SetupState.afterDownload;
    notifyListeners();
    // wait 1 second for ui response
    // await Future.delayed(Duration(seconds: 1));
    await _unZip(savePath);

    await _checkFile(savePath)
        ? logger.i('Unzip done')
        : logger.e('extracting failed');

    await _deleteDownloadedFile(savePath);

    _openHomePage();
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      _progress = (received / total * 100).floorToDouble();
    }
    notifyListeners();
  }

  Future<void> _unZip(String pathToZip) async {
    File zipFile = File(pathToZip);
    var databasesPath = await getDatabasesPath();
    var bytes = zipFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    for (var file in archive) {
      var fileName = path.join(databasesPath, file.name);
      if (file.isFile) {
        var outFile = File(fileName);
        //print('File:: ' + outFile.path);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      }
    }
    // save record to sharedpref
    await SharedPrefProvider.setBool(key: k_key_isDatabaseSaved, value: true);

    await SharedPrefProvider.setInt(
        key: k_key_databaseVersion, value: k_currentDatabaseVersion);
  }

  Future<void> _deleteDownloadedFile(String path) async {
    var file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<bool> _checkFile(String path) async {
    var file = File(path);
    return await file.exists();
  }

  void _openHomePage() {
    Navigator.of(_context).popAndPushNamed('/home');
  }

  void cancelDownload() {
    _cancelToken.cancel();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _dio.close(force: true);
  // }
}
