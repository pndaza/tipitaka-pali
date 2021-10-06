import 'package:flutter/material.dart';

import '../../services/prefs.dart';

class ScriptSettingController extends ChangeNotifier {
  bool _isShowAlternatePali = Prefs.isShowAlternatePali;
  bool _isShowPtsNumber = Prefs.isShowPtsNumber;
  bool _isShowThaiNumber = Prefs.isShowThaiNumber;
  bool _isShowVriNumber = Prefs.isShowVriNumber;

  bool get isShowAlternatePali => _isShowAlternatePali;
  bool get isShowPtsNumber => _isShowPtsNumber;
  bool get isShowThaiNumber => _isShowThaiNumber;
  bool get isShowVriNumber => _isShowVriNumber;

  void onToggleShowAlternatePali(bool value) {
    // save and change ui
    _isShowAlternatePali = value;
    notifyListeners();
    // save to shared preference
    Prefs.isShowAlternatePali = value;
  }

  void onToggleShowPtsNumber(bool value) {
    // save and change ui
    _isShowPtsNumber = value;
    notifyListeners();
    // save to shared preference
    Prefs.isShowPtsNumber = value;
  }

  void onToggleShowThaiNumber(bool value) {
    // save and change ui
    _isShowThaiNumber = value;
    notifyListeners();
    // save to shared preference
    Prefs.isShowThaiNumber = value;
  }

  void onToggleShowVriNumber(bool value) {
    // save and change ui
    _isShowVriNumber = value;
    notifyListeners();
    // save to shared preference
    Prefs.isShowVriNumber = value;
  }
}
