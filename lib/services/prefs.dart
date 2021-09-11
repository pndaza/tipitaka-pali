// import to copy////////////////////
//import 'package:tipitaka_pali/services/prefs.dart';

// Shared prefs package import
import 'package:shared_preferences/shared_preferences.dart';

// preference names
const String LOCALEVAL = "localeVal";
const String THEME_INDEX = "themeIndex";
const String LIGHT_THEME_ON = "lightThemeOn";
const String FONT_SIZE = "fontSize";
const String DATABASE_VERSION = "databaseVersion";
const String IS_DATABASE_SAVED = "isDatabaseSaved";

// default pref values
const int DEFAULT_LOCALEVAL = 0;
const int DEFAULT_THEME_INDEX = 24;
const bool DEFAULT_LIGHT_THEME_ON = true;
const int DEFAULT_FONT_SIZE = 32;
const int DEFAULT_DATABASE_VERSION = 1;
const bool DEFAULT_IS_DATABASE_SAVED = false;

class Prefs {
  static late final SharedPreferences instance;

  static Future<SharedPreferences> init() async =>
      instance = await SharedPreferences.getInstance();

  // get and set the default member values if null
  static int get localeVal => instance.getInt(LOCALEVAL) ?? DEFAULT_LOCALEVAL;
  static set localeVal(int value) => instance.setInt(LOCALEVAL, value);

  static int get themeIndex =>
      instance.getInt(THEME_INDEX) ?? DEFAULT_THEME_INDEX;
  static set themeIndex(int value) => instance.setInt(THEME_INDEX, value);

  static bool get lightThemeOn =>
      instance.getBool(LIGHT_THEME_ON) ?? DEFAULT_LIGHT_THEME_ON;
  static set lightThemeOn(bool value) =>
      instance.setBool(LIGHT_THEME_ON, value);

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
}
