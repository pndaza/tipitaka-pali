import 'package:flutter/material.dart';
import './bookmark_page.dart';
import './recent_page.dart';
import './search_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'home_page.dart';

enum Screen { Home, Bookmark, Recent, Search }

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _getScreen(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          backgroundColor: Theme.of(context).primaryColor,
          selectedItemColor: Theme.of(context).selectedRowColor,
          unselectedItemColor: Theme.of(context).unselectedWidgetColor,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              label: AppLocalizations.of(context)!.home,
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
                label: AppLocalizations.of(context)!.bookmark,
                icon: Icon(Icons.bookmark)),
            BottomNavigationBarItem(
                label: AppLocalizations.of(context)!.recent,
                icon: Icon(Icons.history)),
            BottomNavigationBarItem(
                label: AppLocalizations.of(context)!.search,
                icon: Icon(Icons.search)),
          ],
          onTap: _changePage,
        ));
  }

  _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _getScreen(int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return BookmarkPage();
      case 2:
        return RecentPage();
      case 3:
        return SearchPage();
    }
  }
}
