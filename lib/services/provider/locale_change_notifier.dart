import 'package:flutter/material.dart';
import 'package:tipitaka_pali/services/prefs.dart';

class LocaleChangeNotifier extends ChangeNotifier {
  int _localeVal = Prefs.localeVal;

  String get localeString {
    String localeString = "en";
    switch (_localeVal) {
      case 0:
        localeString = "en";
        break;
      case 1:
        localeString = "my";
        break;
      case 2:
        localeString = "si";
        break;
      case 3:
        localeString = "zh";
        break;
      case 4:
        localeString = "vi";
        break;
      case 5:
        localeString = "hi";
        break;
    }

    return localeString;
  }

  set localeVal(int val) {
    _localeVal = Prefs.localeVal = val;
    notifyListeners();
  }
}
