import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

class MyTheme {
  static final _light = AppTheme.light().copyWith(
      id: 'default_light_theme',
      description: 'default light theme',
      data: ThemeData(fontFamily: 'NotoSansMyanmar'));

  static final _dark = AppTheme.dark().copyWith(
      id: 'default_dark_theme',
      description: 'default dark theme',
      data: ThemeData(brightness: Brightness.dark ,fontFamily: 'NotoSansMyanmar'));

  static final _grey = AppTheme(
      id: 'grey',
      description: 'grey',
      data: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.grey,
          accentColor: Colors.blueAccent,
          fontFamily: 'NotoSansMyanmar'));

  static final _black = AppTheme(
      id: 'black',
      description: 'black',
      data: ThemeData(
          brightness: Brightness.dark,
          // primarySwatch: Colors.grey,
          primaryColor: Colors.black,
          accentColor: Colors.deepOrangeAccent,
          backgroundColor: Colors.black,
          scaffoldBackgroundColor: Colors.black,
          fontFamily: 'NotoSansMyanmar'));

  static final _purple = AppTheme(
      id: "purple",
      description: 'purple',
      data: ThemeData(
          primarySwatch: Colors.purple, fontFamily: 'NotoSansMyanmar'));

  static final _brown = AppTheme(
      id: "brown",
      description: 'brown',
      data: ThemeData(
          primarySwatch: Colors.brown, fontFamily: 'NotoSansMyanmar'));
  static final _orange = AppTheme(
      id: "orange",
      description: 'orange',
      data: ThemeData(
          primarySwatch: Colors.orange, fontFamily: 'NotoSansMyanmar'));
  static final _cyan = AppTheme(
      id: "cyan",
      description: 'cyan',
      data:
          ThemeData(primarySwatch: Colors.cyan, fontFamily: 'NotoSansMyanmar'));
  static final _pink = AppTheme(
      id: "pink",
      description: 'pink',
      data:
          ThemeData(primarySwatch: Colors.pink, fontFamily: 'NotoSansMyanmar'));
  static final _red = AppTheme(
      id: "red",
      description: 'red',
      data:
          ThemeData(primarySwatch: Colors.red, fontFamily: 'NotoSansMyanmar'));

  static List<AppTheme> fetchAll() {
    // return [white, black, ];
    return [
      _light,
      _dark,
      _grey,
      _black,
      _red,
      _pink,
      _brown,
      _cyan,
      _orange,
      _purple
    ];
  }
}
