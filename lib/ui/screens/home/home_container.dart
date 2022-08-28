import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/providers/font_provider.dart';

import '../../../providers/navigation_provider.dart';
import '../../../utils/platform_info.dart';
import 'desktop_home_view.dart';
import 'mobile_navigation_bar.dart';
import 'navigation_pane.dart';
import 'opened_books_provider.dart';

// enum Screen { Home, Bookmark, Recent, Search }

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => OpenedBooksProvider()),
        ChangeNotifierProvider(create: (_) => FontProvider()),
      ],
      child: Scaffold(
          body: PlatformInfo.isDesktop
              ? const DesktopHomeView()
              : const DetailNavigationPane(navigationCount: 5,),
          bottomNavigationBar:
              !PlatformInfo.isDesktop ? const MobileNavigationBar() : null),
    );
  }
}
