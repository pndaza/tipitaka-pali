import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:tipitaka_pali/services/prefs.dart';
import 'package:tipitaka_pali/data/flex_theme_data.dart';

class ThemeChangeNotifier extends ChangeNotifier {
  ThemeMode themeMode = (Prefs.darkThemeOn) ? ThemeMode.dark : ThemeMode.light;
  int _themeIndex = 1;

  set themeIndex(int val) {
    _themeIndex = val;
    notifyListeners();
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;
  toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    Prefs.dartThemeOn = isOn;

    notifyListeners();
  }

  //returns // flexschemedata
  get darkTheme => FlexColorScheme.dark(
        // As scheme colors we use the one from our list
        // pointed to by the current themeIndex.
        colors: myFlexSchemes[Prefs.themeIndex].dark,
        // Medium strength surface branding used in this example.
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ).toTheme;

  ThemeData get themeData =>
      //ThemeData get themeData=>  myFlexSchemes[Prefs.themeIndex].light().toTheme();
      FlexColorScheme.light(
        // As scheme colors we use the one from our list
        // pointed to by the current themeIndex.
        colors: myFlexSchemes[Prefs.themeIndex].light,
        // Medium strength surface branding used in this example.
  surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
      ).toTheme;
}
