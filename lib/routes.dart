import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tipitaka_pali/ui/screens/fask_home.dart';
import 'package:tipitaka_pali/ui/screens/home/home.dart';
import 'package:tipitaka_pali/ui/screens/reader/reader.dart';
import 'package:tipitaka_pali/ui/screens/search_result_view.dart';
import 'package:tipitaka_pali/ui/screens/settings/settings.dart';
import 'package:tipitaka_pali/ui/screens/splash_screen.dart';

const SplashRoute = '/';
const HomeRoute = '/home';
const ReaderRoute = '/reader';
const SearchResultRoute = '/search_result_view';
const SettingRoute = '/setting';
const FakeHomeRoute = '/fake_home';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    late Widget screen;
    switch (settings.name) {
      case SplashRoute:
        screen = SplashScreen();
        break;
      case HomeRoute:
        screen = Home();
        break;
      case FakeHomeRoute:
        screen = FakeHome();
        break;
      case SearchResultRoute:
        if (arguments is Map) {
          screen = SearchResultView(
            searchWord: arguments['searchWord'],
          );
        }
        break;
      case ReaderRoute:
        if (arguments is Map) {
          screen = Reader(
            book: arguments['book'],
            currentPage: arguments['currentPage'],
            textToHighlight: arguments['textToHighlight'],
          );
        }
        break;
      case SettingRoute:
        screen = SettingPage();
        break;
    }
    return MaterialPageRoute(
        builder: (BuildContext context) => ThemeConsumer(child: screen));
  }
}
