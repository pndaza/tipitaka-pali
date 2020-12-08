import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tipitaka_pali/ui/screens/fask_home.dart';
import 'package:tipitaka_pali/ui/screens/home/home.dart';
import 'package:tipitaka_pali/ui/screens/reader/reader.dart';
import 'package:tipitaka_pali/ui/screens/search_result_view.dart';
import 'package:tipitaka_pali/ui/screens/splash_screen.dart';

const SplashRoute = '/';
const HomeRoute = '/home';
const ReaderRoute = '/reader';
const SearchResultRoute = '/search_result_view';
const FakeHomeRoute = '/fake_home';

RouteFactory buildRoutes() {
    return (settings) {
      final Map<String, dynamic> arguments = settings.arguments;
      Widget screen;
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
          screen = SearchResultView(
            searchWord: arguments['searchWord'],
          );
          break;
        case ReaderRoute:
          final currentPage =
              arguments['currentPage'] == null ? 1 : arguments['currentPage'];
          screen = Reader(
            book: arguments['book'],
            currentPage: currentPage,
            textToHighlight: arguments['textToHighlight'],
          );
          break;
        default:
          return null;
      }
      return MaterialPageRoute(
          builder: (BuildContext context) => ThemeConsumer(child: screen));
    };
  }