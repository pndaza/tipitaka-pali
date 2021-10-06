import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'routes.dart';
import 'services/provider/locale_change_notifier.dart';
import 'services/provider/script_language_provider.dart';
import 'services/provider/theme_change_notifier.dart';
import 'ui/screens/splash_screen.dart';

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
  //final List<AppTheme> themes = MyTheme.fetchAll();

  @override
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeChangeNotifier>(
              create: (context) => ThemeChangeNotifier(),
            ),
            ChangeNotifierProvider<LocaleChangeNotifier>(
              create: (context) => LocaleChangeNotifier(),
            ),
            ChangeNotifierProvider<ScriptLanguageProvider>(
              create: (context) => ScriptLanguageProvider(),
            ),
          ],
          builder: (context, _) {
            final themeChangeNotifier =
                Provider.of<ThemeChangeNotifier>(context);
            final localChangeNotifier =
                Provider.of<LocaleChangeNotifier>(context);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: themeChangeNotifier.themeMode,
              theme: themeChangeNotifier.themeData,
              darkTheme: themeChangeNotifier.darkTheme,
              locale: Locale(localChangeNotifier.localeString, ''),
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
              home:  SplashScreen(),
            );
          } // builder
          );
}
