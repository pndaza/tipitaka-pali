import 'package:flutter/material.dart';

import '../services/prefs.dart';

class FontProvider extends ChangeNotifier {
  late int _fontSize;
  int get fontSize => _fontSize;

  FontProvider() {
    _init();
  }

  void _init() {
    _fontSize = Prefs.fontSize;
  }

  void onIncreaseFontSize() {
    _fontSize += 1;
    Prefs.fontSize = _fontSize;
    notifyListeners();
  }

  void onDecreaseFontSize() {
    _fontSize -= 1;
    Prefs.fontSize = _fontSize;
    notifyListeners();
  }
}
