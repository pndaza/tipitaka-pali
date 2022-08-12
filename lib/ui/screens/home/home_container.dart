import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../routes.dart';
import '../../../utils/platform_info.dart';
import '../dictionary_page.dart';
import '../reader/reader_container.dart';
import '../settings/settings.dart';
import 'book_list_page.dart';
import 'bookmark_page.dart';
import 'dekstop_navigation_bar.dart';
import 'mobile_navigation_bar.dart';
import 'opened_books_provider.dart';
import 'recent_page.dart';
import 'search_page/search_page.dart';

// enum Screen { Home, Bookmark, Recent, Search }

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isShowing = true;
  final _width = 350.0;

  late final AnimationController _scaleAnimationController;
  late final AnimationController _animatedIconController;
  late final Animation<double> _animation;
  final Tween<double> _tween = Tween(begin: 1.0, end: 0.0);

  @override
  void initState() {
    super.initState();

    _scaleAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animation = CurvedAnimation(
      parent: _scaleAnimationController,
      curve: Curves.fastOutSlowIn,
    );

    _animatedIconController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _animatedIconController.dispose();
    _scaleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => OpenedBooksProvider(),
        child: Scaffold(
            body: PlatformInfo.isDesktop
                ? Stack(
                    children: [
                      Row(
                        children: [
                          DeskTopNavigationBar(
                            selectedIndex: _currentIndex,
                            onDestinationSelected: _changePage,
                          ),
                          // used as vertical divider
                          Container(
                            width: 1,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 2)
                              ],
                            ),
                          ),
                          SizeTransition(
                              sizeFactor: _tween.animate(_animation),
                              axis: Axis.horizontal,
                              axisAlignment: 1,
                              child: SizedBox(
                                  width: _width,
                                  child: _getScreen(context, _currentIndex))),
                          const Expanded(child: ReaderContainer()),
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
                                  if (_scaleAnimationController.status ==
                                      AnimationStatus.completed) {
                                    _scaleAnimationController.reverse();
                                    _animatedIconController.reverse();
                                  } else {
                                    _scaleAnimationController.forward();
                                    _animatedIconController.forward();
                                  }
                                  // if (_isShowing) {
                                  //   _animatedIconController.reverse();
                                  //   _scaleAnimationController.reverse();
                                  // } else {
                                  //   _animatedIconController.forward();
                                  //   _scaleAnimationController.forward();
                                  // }
                                  _isShowing = !_isShowing;
                                },
                                icon: AnimatedIcon(
                                  icon: AnimatedIcons.arrow_menu,
                                  progress: _animatedIconController,
                                )),
                          ),
                        ),
                      )
                    ],
                  )
                : _getScreen(context, _currentIndex),
            bottomNavigationBar: !PlatformInfo.isDesktop
                ? MobileNavigationBar(
                    selectedIndex: _currentIndex,
                    onDestinationSelected: _changePage,
                  )
                : null));
  }

  void _changePage(int index) {
    if (_scaleAnimationController.status == AnimationStatus.completed) {
      _scaleAnimationController.reverse();
      _animatedIconController.reverse();
    }
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
        _isShowing = !_isShowing;
      });
    }
  }

  Widget _getScreen(BuildContext context, int index) {
    switch (index) {
      case 0:
        return BookListPage();
      case 1:
        return const RecentPage();
      case 2:
        return const BookmarkPage();
      case 3:
        if (PlatformInfo.isDesktop) {
          return const Navigator(
              initialRoute: '/search',
              onGenerateRoute: RouteGenerator.generateRoute);
        } else {
          return const SearchPage();
        }
      case 4:
        return const DictionaryPage();
      // only in desktop
      case 5:
        return const SettingPage();
      default:
        throw Error();
    }
  }
}
