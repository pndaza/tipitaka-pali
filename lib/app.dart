import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tipitaka_pali/routes.dart';

import 'data/theme_data.dart';
import 'ui/screens/splash_screen.dart';

final Logger logger = Logger(
    printer: PrettyPrinter(
  methodCount: 0,
  errorMethodCount: 5,
  lineLength: 50,
  colors: true,
  printEmojis: true,
  printTime: false,
));

class App extends StatelessWidget {
  final List<AppTheme> themes = MyTheme.fetchAll();

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
        saveThemesOnChange: true,
        loadThemeOnInit: true,
        defaultThemeId: themes.first.id,
        themes: themes,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateRoute: buildRoutes(),
          home: ThemeConsumer(child: SplashScreen()),
        ));
  }
}
