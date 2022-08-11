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

class _HomeState extends State<Home> with TickerProviderStateMixin {
  // final isMobile = Platform.isAndroid || Platform.isIOS;

  int _currentIndex = 0;
  bool isExtended = false;

  late final AnimationController _animationController;

  late double masterWidth;
  @override
  void initState() {
    super.initState();
    masterWidth = 350;
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => OpenedBooksProvider(),
        child: Scaffold(
            body: Stack(
              children: [
                Row(
                  children: [
                    NavigationRail(
                      leading: Ink.image(
                        height: 48,
                        width: 48,
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
                      // labelType: NavigationRailLabelType.all,
                      groupAlignment: -1.0,
                      selectedIndex: _currentIndex,
                      extended: isExtended,
                      onDestinationSelected: _changePage,
                    ),
                    Expanded(
                        child: MasterDetailContainer(
                      master: _getScreen(context, _currentIndex),
                      detail: const ReaderContainer(),
                      isDesktop: PlatformInfo.isDesktop,
                      masterWidth: masterWidth,
                    )),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: Center(
                      child: IconButton(
                          onPressed: () {
                            setState(() {
                              if (masterWidth == 0) {
                                _animationController.reverse();
                                masterWidth = 350;
                              } else {
                                _animationController.forward();
                                masterWidth = 0;
                              }
                            });
                          },
                          icon: AnimatedIcon(
                            icon: AnimatedIcons.arrow_menu,
                            progress: _animationController,
                          )),
                    ),
                  ),
                )
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

  Widget _getScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        return HomePage();
      case 1:
        return const RecentPage();
      case 2:
        return const BookmarkPage();
      case 3:
        return const Navigator(
            initialRoute: '/search',
            onGenerateRoute: RouteGenerator.generateRoute);
      // only in desktop
      case 4:
        return const DictionaryPage();
      case 5:
        return const SettingPage();
      default:
        return HomePage();
    }
  }
}
