// import to copy////////////////////
//import 'package:tipitaka_pali/services/prefs.dart';

// Shared prefs package import
import 'package:shared_preferences/shared_preferences.dart';

// preference names
const String LOCALEVAL = "localeVal";
const String THEME_INDEX = "themeIndex";
const String DARK_THEME_ON = "darkThemeOn";
const String FONT_SIZE = "fontSize";
const String DATABASE_VERSION = "databaseVersion";
const String IS_DATABASE_SAVED = "isDatabaseSaved";
const String IS_SHOW_ALTERNATE_PALI = 'showAlternatePali';
const String IS_SHOW_PTS_NUMBER = 'showPtsNumber';
const String IS_SHOW_THAI_NUMBER = 'showThaiNumber';
const String IS_SHOW_VRI_NUMBER = 'showVriNumber';

// default pref values
const int DEFAULT_LOCALEVAL = 0;
const int DEFAULT_THEME_INDEX = 24;
const bool DEFAULT_DARK_THEME_ON = false;
const int DEFAULT_FONT_SIZE = 12;
const int DEFAULT_DATABASE_VERSION = 1;
const bool DEFAULT_IS_DATABASE_SAVED = false;
const bool DEFAULT_SHOW_ALTERNATE_PALI = false;
const bool DEFAULT_SHOW_PTS_NUMBER = false;
const bool DEFAULT_SHOW_THAI_NUMBER = false;
const bool DEFAULT_SHOW_VRI_NUMBER = false;

class Prefs {
  // prevent object creation
  Prefs._();
  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  // get and set the default member values if null
  static int get localeVal => instance.getInt(LOCALEVAL) ?? DEFAULT_LOCALEVAL;
  static set localeVal(int value) => instance.setInt(LOCALEVAL, value);

  static int get themeIndex =>
      instance.getInt(THEME_INDEX) ?? DEFAULT_THEME_INDEX;
  static set themeIndex(int value) => instance.setInt(THEME_INDEX, value);

  static bool get dartThemeOn =>
      instance.getBool(DARK_THEME_ON) ?? DEFAULT_DARK_THEME_ON;
  static set dartThemeOn(bool value) => instance.setBool(DARK_THEME_ON, value);

  static int get fontSize => instance.getInt(FONT_SIZE) ?? DEFAULT_FONT_SIZE;
  static set fontSize(int value) => instance.setInt(FONT_SIZE, value);

  static int get databaseVersion =>
      instance.getInt(DATABASE_VERSION) ?? DEFAULT_DATABASE_VERSION;
  static set databaseVersion(int value) =>
      instance.setInt(DATABASE_VERSION, value);

  static bool get isDatabaseSaved =>
      instance.getBool(IS_DATABASE_SAVED) ?? DEFAULT_IS_DATABASE_SAVED;
  static set isDatabaseSaved(bool value) =>
      instance.setBool(IS_DATABASE_SAVED, value);

  static bool get isShowAlternatePali =>
      instance.getBool(IS_SHOW_ALTERNATE_PALI) ?? DEFAULT_SHOW_ALTERNATE_PALI;
  static set isShowAlternatePali(bool value) =>
      instance.setBool(IS_SHOW_ALTERNATE_PALI, value);

  static bool get isShowPtsNumber =>
      instance.getBool(IS_SHOW_PTS_NUMBER) ?? DEFAULT_SHOW_PTS_NUMBER;
  static set isShowPtsNumber(bool value) =>
      instance.setBool(IS_SHOW_PTS_NUMBER, value);

  static bool get isShowThaiNumber =>
      instance.getBool(IS_SHOW_THAI_NUMBER) ?? DEFAULT_SHOW_THAI_NUMBER;
  static set isShowThaiNumber(bool value) =>
      instance.setBool(IS_SHOW_THAI_NUMBER, value);

  static bool get isShowVriNumber =>
      instance.getBool(IS_SHOW_VRI_NUMBER) ?? DEFAULT_SHOW_VRI_NUMBER;
  static set isShowVriNumber(bool value) =>
      instance.setBool(IS_SHOW_VRI_NUMBER, value);
}
