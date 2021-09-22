import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tipitaka_pali/business_logic/models/definition.dart';
import 'package:tipitaka_pali/business_logic/view_models/dictionary_provider.dart';
import 'package:tipitaka_pali/services/prefs.dart';
import 'package:tipitaka_pali/services/storage/asset_loader.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum DictAlgorithm { Auto, TPR, DPR }

extension ParseToString on DictAlgorithm {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class DictionaryViewModel with ChangeNotifier {
  BuildContext _context;
  String _word;
  String _definition = '';
  late String _cssData;
  late int _fontSize;
  // DictAlgorithm dictAlgorithm = DictAlgorithm.Auto;
  DictAlgorithm _currentAlgorithmMode = DictAlgorithm.Auto;
  DictAlgorithm get currentAlgorithmMode => _currentAlgorithmMode;

  WebViewController? webViewController;
  DictionaryViewModel(this._context, this._word) {
// init
    _init();
  }

  String get definition => _definition;

  Future<void> _init() async {
    // load resources
    _cssData = await AssetsProvider.loadCSS(
        Prefs.lightThemeOn ? 'dict_day.css' : 'dict_night.css');
    _fontSize = Prefs.fontSize;
    loadDefinition(_word);
  }

  Future<void> loadDefinition(String word) async {
    switch (_currentAlgorithmMode) {
      case DictAlgorithm.Auto:
        _definition = await searchAuto(word);
        break;
      case DictAlgorithm.TPR:
        _definition = await searchWithTPR(word);
        break;
      case DictAlgorithm.DPR:
        _definition = await searchWithDPR(word);
        break;
    }

    if (_definition.isEmpty) {
      _definition = _buildNotFoundInfo();
    }

    notifyListeners();
  }

  Future<String> searchAuto(String word) async {
    //
    // Audo mode will use TPR algorithm first
    // if defintion was found, will be display this definition
    // Otherwise will be display result of DPR a
    final definition = await searchWithTPR(word);
    if (definition.isNotEmpty) return definition;
    return await searchWithDPR(word);
  }

  Future<String> searchWithTPR(String word) async {
    // looking up using estimated stem word
    final dictionaryProvider = DictionaryProvider(_context);
    final definitions =
        await dictionaryProvider.getDefinition(word, isAlreadyStem: false);

    if (definitions.isEmpty) return '';

    print('stemming algorithm is works for $word word ');
    print('formmatting result for display');
    return _formatDefinitions(definitions);
  }

  Future<String> searchWithDPR(String word) async {
    // looking up using dpr breakup words
    final dictionaryProvider = DictionaryProvider(_context);

    final String breakupText = await dictionaryProvider.getBreakup(word);
    if (breakupText.isEmpty) return '';

    final List<String> words = getWordsFrom(breakup: breakupText);
    // formating header
    String formatedDefintion = '<b>$word</b> - ';
    final firstPartOfBreakupText =
        breakupText.substring(0, breakupText.indexOf(' '));
    String lastPartOfBreakupText =
        words.map((word) => '<b style="color:#440000">$word</b>').join(' + ');
    formatedDefintion += '$firstPartOfBreakupText [ $lastPartOfBreakupText ]';

    // getting definition per word
    for (var word in words) {
      final definitions =
          await dictionaryProvider.getDefinition(word, isAlreadyStem: true);
      // print(definitions);
      if (definitions.isNotEmpty) {
        formatedDefintion += _formatDefinitions(definitions);
      }
    }

    return formatedDefintion;
  }

  Future<void> onTextChanged(String word) async {
    print('searching: $word');
    await loadDefinition(word);
    // webViewController?.loadUrl(_getUri(_definition).toString());
    // notifyListeners();
  }

  Uri _getUri(String pageContent) {
    return Uri.dataFromString('<!DOCTYPE html> $pageContent',
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'));
  }

  String _formatDefinitions(List<Definition> definitions) {
    String formattedDefinition = '';
    for (Definition definition in definitions) {
      formattedDefinition += _addStyleToBook(definition.bookName);
      formattedDefinition += definition.definition;
    }
    return _buildHtmlContent(formattedDefinition);
  }

  String _buildNotFoundInfo() {
    final content = '<p style = "text-align:center">not found</p>';
    return _buildHtmlContent(content);
  }

  String _addStyleToBook(String book) {
    return '\n<p class="book">$book</p>\n';
  }

  String _buildHtmlContent(String formattedDefinition) {
    return '''
      <html>
      <head><meta name="viewport" content="width=device-width, initial-scale=1.0"></head>
      <style>
      html {font-size: $_fontSize%}
      $_cssData
      </style>
      <body>
      $formattedDefinition
      </body>
      </html>
      ''';
  }

  List<String> getWordsFrom({required String breakup}) {
    // the dprBreakup data look like this:
    // 'bhikkhu':'bhikkhu (bhikkhu)',
    //
    // or this:
    // 'āyasmā':'āyasmā (āya, āyasmant, āyasmanta)',
    //
    // or this:
    // 'asaṃkiliṭṭhaasaṃkilesiko':'asaṃ-kiliṭṭhā-saṃkilesiko (asa, asā, kiliṭṭha, saṃkilesiko)',
    //
    // - The key of the dprBreakup object is the word being look up here (the "key" parameter of this function)
    // - The format of the break up is as follows:
    //   - the original word broken up with dashes (-) and the components of the breakup as dictionary entries in ()
    //
    final indexOfLeftBracket = breakup.indexOf(' (');
    final indexOfRightBracket = breakup.indexOf(')');
    var breakupWords = breakup
        .substring(indexOfLeftBracket + 2, indexOfRightBracket)
        .split(', ');
    // cleans up DPR-specific stuff
    breakupWords =
        breakupWords.map((word) => word.replaceAll('`', '')).toList();
    return breakupWords;
  }

  void onAlgorithmModeChanged(DictAlgorithm? value) {
    if (value != null) {
      _currentAlgorithmMode = value;
      print(value);
      _init();
    }
  }
}
