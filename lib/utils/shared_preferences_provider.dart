import 'package:shared_preferences/shared_preferences.dart';

// enum SharedPrefKeys  {
//   DATABASE_VERSION,
//   IS_DATABASE_SAVED,
//   FONT_SIZE
// }

// extension ParseToString on SharedPrefKeys {
//   String toKeyString() {
//     return this.toString().split('.').last;
//   }
// }

class SharedPrefProvider {
  SharedPrefProvider._();

  // static const String key_font_size = 'font-size';
  // static const String key_db_version = 'database_version';

  static Future<int> getInt({String key}) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getInt(key) ?? 100;
  }

  static Future<bool> setInt({String key, int value}) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setInt(key, value);
  }

  static Future<String> getString({String key}) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(key);
  }

  static Future<bool> setString({String key, String value}) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setString(key, value);
  }

  static Future<bool> getBool({String key}) async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(key);
  }

  static Future<bool> setBool({String key, bool value}) async {
    final pref = await SharedPreferences.getInstance();
    return await pref.setBool(key, value);
  }
}
