import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DeskTopNavigationBar extends StatelessWidget {
  const DeskTopNavigationBar({
    Key? key,
    required this.selectedIndex,
    this.onDestinationSelected,
  }) : super(key: key);

  final int selectedIndex;
  final ValueChanged<int>? onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.zero;

    return NavigationRail(
      leading: Ink.image(
        height: 48,
        width: 48,
        image: const AssetImage('assets/icon/icon.png'),
        fit: BoxFit.scaleDown,
      ),
      destinations: [
        NavigationRailDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: Text(AppLocalizations.of(context)!.home),
          padding: padding,
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.history_outlined),
          selectedIcon: const Icon(Icons.history),
          label: Text(AppLocalizations.of(context)!.recent),
          padding: padding,
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.bookmark_outline),
          selectedIcon: const Icon(Icons.bookmark),
          label: Text(AppLocalizations.of(context)!.bookmark),
          padding: padding,
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.find_in_page_outlined),
          selectedIcon: const Icon(Icons.find_in_page),
          label: Text(AppLocalizations.of(context)!.search),
          padding: padding,
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.search_outlined),
          selectedIcon: const Icon(Icons.search),
          label: Text(AppLocalizations.of(context)!.dictionary),
          padding: padding,
        ),
        NavigationRailDestination(
          icon: const Icon(Icons.settings_outlined),
          selectedIcon: const Icon(Icons.settings),
          label: Text(AppLocalizations.of(context)!.settings),
          padding: padding,
        ),
      ],
      // labelType: NavigationRailLabelType.all,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
    );
  }
}
