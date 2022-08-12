import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MobileNavigationBar extends StatelessWidget {
  const MobileNavigationBar({
    Key? key,
    required this.selectedIndex,
    this.onDestinationSelected,
  }) : super(key: key);

  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: [
        NavigationDestination(
          label: AppLocalizations.of(context)!.home,
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
        ),
        NavigationDestination(
          label: AppLocalizations.of(context)!.recent,
          icon: const Icon(Icons.history_outlined),
          selectedIcon: const Icon(Icons.history),
        ),
        NavigationDestination(
          label: AppLocalizations.of(context)!.bookmark,
          icon: const Icon(Icons.bookmark_outline),
          selectedIcon: const Icon(Icons.bookmark),
        ),
        NavigationDestination(
          label: AppLocalizations.of(context)!.search,
          icon: const Icon(Icons.find_in_page_outlined),
          selectedIcon: const Icon(Icons.find_in_page),
        ),
        NavigationDestination(
          label: AppLocalizations.of(context)!.dictionary,
          icon: const Icon(Icons.search_outlined),
          selectedIcon: const Icon(Icons.search),
        ),
      ],
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
    );
  }
}
