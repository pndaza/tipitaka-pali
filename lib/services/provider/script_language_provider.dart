import 'package:flutter/material.dart';

import '../prefs.dart';

class ScriptLanguageProvider extends ChangeNotifier{
    String _currentLanguage = Prefs.currentScriptLanguage;
    List<String> get langauges => <String>['Roman', 'မြန်မာ'];
  String get currentLanguage => _currentLanguage;

    void onLanguageChage(String? value) {
    if (value != null) {
      _currentLanguage = value;
      notifyListeners();
      Prefs.currentScriptLanguage = value;
    }
  }
}