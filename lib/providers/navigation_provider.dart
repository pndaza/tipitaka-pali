import 'package:flutter/material.dart';

// final currentNavigation = ValueNotifier(0);
// final isNavigationViewOpened = ValueNotifier(true);

class NavigationProvider extends ChangeNotifier {
  int currentNavigation = 0;
  bool isNavigationPaneOpened = true;

  void onClickedNavigationItem(int index) {
    if (!isNavigationPaneOpened) {
      isNavigationPaneOpened = !isNavigationPaneOpened;
      currentNavigation = index;
    } else if (currentNavigation == index) {
      isNavigationPaneOpened = !isNavigationPaneOpened;
    } else {
      currentNavigation = index;
    }
    notifyListeners();
  }

  void toggleNavigationPane() {
    isNavigationPaneOpened = !isNavigationPaneOpened;
    notifyListeners();
  }
}
