import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/providers/navigation_provider.dart';

import '../../../routes.dart';
import '../../../utils/platform_info.dart';
import '../dictionary_page.dart';
import '../settings/settings.dart';
import 'book_list_page.dart';
import 'bookmark_page.dart';
import 'recent_page.dart';
import 'search_page/search_page.dart';

class DetailNavigationPane extends StatefulWidget {
  const DetailNavigationPane({Key? key, required this.navigationCount}) : super(key: key);
  final int navigationCount;

  @override
  State<DetailNavigationPane> createState() => _DetailNavigationPaneState();
}

class _DetailNavigationPaneState extends State<DetailNavigationPane> {
  late final NavigationProvider navigationProvider;
  late final PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
    navigationProvider = context.read<NavigationProvider>();
    navigationProvider.addListener(_pageChangeListener);
  }

  @override
  void dispose() {
    navigationProvider.removeListener(_pageChangeListener);
    pageController.dispose();
    super.dispose();
  }

  void _pageChangeListener() {
    int index = context.read<NavigationProvider>().currentNavigation;
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.navigationCount, // todo
        itemBuilder: (context, index) {
          return _getPage(context, index);
        });
  }

  Widget _getPage(BuildContext context, int index) {
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
