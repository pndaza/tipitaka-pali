import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/ui/screens/dictionary_page.dart';
import 'package:tipitaka_pali/ui/screens/home/opened_books_provider.dart';
import 'package:tipitaka_pali/ui/screens/reader/reader_container.dart';
import 'package:tipitaka_pali/ui/screens/settings/settings.dart';
import 'package:tipitaka_pali/ui/widgets/master_detail_container.dart';
import 'package:tipitaka_pali/utils/platform_info.dart';
import '../../../routes.dart';
import './bookmark_page.dart';
import './recent_page.dart';
import 'search_page/search_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'home_page.dart';

// enum Screen { Home, Bookmark, Recent, Search }

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final isMobile = Platform.isAndroid || Platform.isIOS;

  int _currentIndex = 0;

  bool isExtended = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => OpenedBooksProvider(),
        child: Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  leading: Ink.image(
                    height: 64,
                    width: 64,
                    image: const AssetImage('assets/icon/icon.png'),
                    fit: BoxFit.scaleDown,
                  ),
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(Icons.home),
                      label: Text(AppLocalizations.of(context)!.home),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.history),
                      label: Text(AppLocalizations.of(context)!.recent),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.bookmark),
                      label: Text(AppLocalizations.of(context)!.bookmark),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.search),
                      label: Text(AppLocalizations.of(context)!.search),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.find_in_page),
                      label: Text(AppLocalizations.of(context)!.dictionary),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.settings),
                      label: Text(AppLocalizations.of(context)!.settings),
                    ),
                  ],
                  selectedIndex: _currentIndex,
                  extended: isExtended,
                  onDestinationSelected: _changePage,
                ),
                Expanded(child: _getScreen(context, _currentIndex)),
              ],
            ),
            bottomNavigationBar: !PlatformInfo.isDesktop
                ? BottomNavigationBar(
                    type: BottomNavigationBarType.shifting,
                    backgroundColor: Theme.of(context).primaryColor,
                    selectedItemColor: Theme.of(context).primaryColor,
                    unselectedItemColor:
                        Theme.of(context).unselectedWidgetColor,
                    currentIndex: _currentIndex,
                    items: [
                      BottomNavigationBarItem(
                        label: AppLocalizations.of(context)!.home,
                        icon: const Icon(Icons.home),
                      ),
                      BottomNavigationBarItem(
                          label: AppLocalizations.of(context)!.recent,
                          icon: const Icon(Icons.history)),
                      BottomNavigationBarItem(
                          label: AppLocalizations.of(context)!.bookmark,
                          icon: const Icon(Icons.bookmark)),
                      BottomNavigationBarItem(
                          label: AppLocalizations.of(context)!.search,
                          icon: const Icon(Icons.search)),
                    ],
                    onTap: _changePage,
                  )
                : null));
  }

  _changePage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _getScreen(BuildContext context, int index) {
    const readerContainer = ReaderContainer();
    switch (index) {
      case 0:
        return MasterDetailContainer(
          master: HomePage(),
          detail: readerContainer,
          isDesktop: PlatformInfo.isDesktop,
        );
      case 1:
        return MasterDetailContainer(
          master: const RecentPage(),
          detail: readerContainer,
          isDesktop: PlatformInfo.isDesktop,
        );
      case 2:
        return MasterDetailContainer(
          master: const BookmarkPage(),
          detail: readerContainer,
          isDesktop: PlatformInfo.isDesktop,
        );
      case 3:
        return MasterDetailContainer(
          master: const Navigator(
            initialRoute: '/search',
            onGenerateRoute: RouteGenerator.generateRoute),
          detail: readerContainer,
          isDesktop: PlatformInfo.isDesktop,
        );
      // only in desktop
      case 4:
        return MasterDetailContainer(
          master: const DictionaryPage(),
          detail: readerContainer,
          isDesktop: PlatformInfo.isDesktop,
        );
      case 5:
        return MasterDetailContainer(
          master: const SettingPage(),
          detail: readerContainer,
          isDesktop: PlatformInfo.isDesktop,
        );
    }
  }
}
