import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tipitaka_pali/business_logic/view_models/dictionary_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DictionaryViewModel with ChangeNotifier {
  BuildContext _context;
  String _word;
  String _definition = '';
  WebViewController? webViewController;
  DictionaryViewModel(this._context, this._word);

  String get definition {
    if (_definition.isEmpty) {
      getDefinition(_word, isStem: false);
    }
    return _definition;
  }

  Future<void> getDefinition(String word, {bool isStem = false}) async {
    final dictionaryProvider = DictionaryProvider(_context);
    _definition =
        await dictionaryProvider.getDefinition(word, isAlreadyStem: isStem);
    notifyListeners();
  }

  Future<void> doSearch(String word) async {
    await getDefinition(word, isStem: true);
    webViewController?.loadUrl(_getUri(_definition).toString());
    notifyListeners();
  }

  Uri _getUri(String pageContent) {
    return Uri.dataFromString('<!DOCTYPE html> $pageContent',
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'));
  }
}
