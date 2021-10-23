import 'package:flutter/material.dart';

import '../prefs.dart';

class ScriptLanguageProvider extends ChangeNotifier {
  String _currentLanguage = Prefs.currentScriptLanguage;
  List<String> get languages =>
      <String>['Roman', 'မြန်မာ', 'සිංහල', 'देवनागरी'];
  String get currentLanguage => _currentLanguage;

  void onLanguageChage(String? value) {
    if (value != null) {
      _currentLanguage = value;
      notifyListeners();
      Prefs.currentScriptLanguage = value;
    }
  }
}
