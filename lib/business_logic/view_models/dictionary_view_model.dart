import 'package:flutter/material.dart';
import 'package:tipitaka_pali/business_logic/models/definition.dart';
import 'package:tipitaka_pali/business_logic/view_models/dictionary_state.dart';
import 'package:tipitaka_pali/services/database/database_helper.dart';
import 'package:tipitaka_pali/services/database/dictionary_service.dart';
import 'package:tipitaka_pali/services/repositories/ditionary_repo.dart';

enum DictAlgorithm { Auto, TPR, DPR }

extension ParseToString on DictAlgorithm {
  String toStr() {
    return toString().split('.').last;
  }
}

class DictionaryViewModel with ChangeNotifier {
  String? _word;

  late DictionaryState _dictionaryState;
  DictionaryState get dictionaryState => _dictionaryState;
  DictAlgorithm _currentAlgorithmMode = DictAlgorithm.Auto;
  DictAlgorithm get currentAlgorithmMode => _currentAlgorithmMode;

  DictionaryViewModel(this._word) {
    _init();
  }

  Future<void> _init() async {
    if (_word == null) {
      //print('there is no initial lookup word');
      _dictionaryState = const DictionaryState.initial();
      notifyListeners();
      return;
    }
    _lookupDefinition();
  }

  Future<void> _lookupDefinition() async {
    _dictionaryState = const DictionaryState.loading();
    notifyListeners();
    // loading definitions
    final definition = await loadDefinition(_word!);
    if (definition.isEmpty) {
      _dictionaryState = const DictionaryState.noData();
      notifyListeners();
    } else {
      _dictionaryState = DictionaryState.data(definition);
      notifyListeners();
    }
  }

  Future<String> loadDefinition(String word) async {
    switch (_currentAlgorithmMode) {
      case DictAlgorithm.Auto:
        return await searchAuto(word);
      case DictAlgorithm.TPR:
        return searchWithTPR(word);
      case DictAlgorithm.DPR:
        return searchWithDPR(word);
    }
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
    final dictionaryProvider =
        DictionarySerice(DictionaryDatabaseRepository(DatabaseHelper()));
    final definitions =
        await dictionaryProvider.getDefinition(word, isAlreadyStem: false);

    if (definitions.isEmpty) return '';

    return _formatDefinitions(definitions);
  }

  Future<String> searchWithDPR(String word) async {
    // looking up using dpr breakup words
    final dictionaryProvider =
        DictionarySerice(DictionaryDatabaseRepository(DatabaseHelper()));

    // frist dpr_stem will be used for stem
    // stem is single word mostly
    final String dprStem = await dictionaryProvider.getDprStem(word);
    if (dprStem.isNotEmpty) {
      final definitions =
          await dictionaryProvider.getDefinition(dprStem, isAlreadyStem: true);
      if (definitions.isNotEmpty) {
        return _formatDefinitions(definitions);
      }
    }

  // not found in dpr_stem
  // will be lookup in dpr_breakup
  // breakup is multi-words 
    final String breakupText = await dictionaryProvider.getDprBreakup(word);
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

  Future<void> onClickSuggestion(String word) async {
    _word = word;
    _lookupDefinition();
  }

  Future<List<String>> getSuggestions(String word) {
    return DictionarySerice(DictionaryDatabaseRepository(DatabaseHelper()))
        .getSuggestions(word);
  }

  String _formatDefinitions(List<Definition> definitions) {
    String formattedDefinition = '';
    for (Definition definition in definitions) {
      formattedDefinition += _addStyleToBook(definition.bookName);
      formattedDefinition += definition.definition;
    }
    return formattedDefinition;
  }

  String _addStyleToBook(String book) {
    return '<h3>$book</h3>\n<br>\n';
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

  void onModeChanged(DictAlgorithm? value) {
    if (value != null) {
      _currentAlgorithmMode = value;
      _lookupDefinition();
    }
  }
}
