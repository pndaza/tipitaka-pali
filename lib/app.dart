import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tipitaka_pali/routes.dart';

import 'data/theme_data.dart';
import 'ui/screens/splash_screen.dart';

// #docregion LocalizationDelegatesImport
import 'package:flutter_localizations/flutter_localizations.dart';

// #enddocregion LocalizationDelegatesImport
// #docregion AppLocalizationsImport
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// #enddocregion AppLocalizationsImport

final Logger myLogger = Logger(
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
          onGenerateRoute: RouteGenerator.generateRoute,
          localizationsDelegates: [
            AppLocalizations.delegate, // Add this line
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', ''), // English, no country code
            Locale('my', ''), // Myanmar, no country code
            Locale('si', ''), // Myanmar, no country code
          ],
          home: ThemeConsumer(child: SplashScreen()),
        ));
  }
}
