import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:tipitaka_pali/services/prefs.dart';
import 'package:tipitaka_pali/data/flex_theme_data.dart';
import 'package:tipitaka_pali/data/constants.dart';

class ThemeChangeNotifier extends ChangeNotifier {
  ThemeMode themeMode = (Prefs.darkThemeOn) ? ThemeMode.dark : ThemeMode.light;
  int _themeIndex = 1;
  List<bool> isSelected = [true, false, false];

  set themeIndex(int val) {
    _themeIndex = val;
    notifyListeners();
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  toggleTheme(int index) {
    themeMode = ThemeMode.light;
    for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
      if (buttonIndex == index) {
        isSelected[buttonIndex] = true;
      } else {
        isSelected[buttonIndex] = false;
      }
    }

    switch (index) {
      case 0:
        Prefs.selectedPageColor = Colors.white.value;
        themeMode = ThemeMode.light;
        Prefs.darkThemeOn = false;
        break;
      case 1:
        Prefs.selectedPageColor = seypia;
        themeMode = ThemeMode.light;
        Prefs.darkThemeOn = false;

        break;
      case 2:
        Prefs.selectedPageColor = Colors.black.value;
        themeMode = ThemeMode.dark;
        Prefs.darkThemeOn = true;

        break;
      default:
        Prefs.selectedPageColor = Colors.white.value;
        themeMode = ThemeMode.light;
        Prefs.darkThemeOn = false;
        break;
    }

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
