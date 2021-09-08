import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:tipitaka_pali/routes.dart';

import 'data/theme_data.dart';
import 'ui/screens/splash_screen.dart';

// #docregion LocalizationDelegatesImport
import 'package:flutter_localizations/flutter_localizations.dart';

// #enddocregion LocalizationDelegatesImport
// #docregion AppLocalizationsImport
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// #enddocregion AppLocalizationsImport

// theme and localization provider includes
// for multiProvider here
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/services/provider/locale_change_notifier.dart';
import 'package:tipitaka_pali/services/provider/theme_change_notifier.dart';

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
