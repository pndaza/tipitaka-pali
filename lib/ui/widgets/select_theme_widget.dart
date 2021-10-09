import 'package:tipitaka_pali/data/flex_theme_data.dart';
import 'package:tipitaka_pali/services/provider/theme_change_notifier.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/services/prefs.dart';

class SelectThemeWidget extends StatelessWidget {
  /*const*/ const SelectThemeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    //final TextTheme textTheme = theme.textTheme;
    //final TextStyle headline4 = textTheme.headline4!;
    final bool isLight = Theme.of(context).brightness == Brightness.light;
    //final ThemeMode themeMode;
    //final ValueChanged<ThemeMode> onThemeModeChanged;
    //final ValueChanged<int> onSchemeChanged;
    //final FlexSchemeData flexSchemeData;

    // Popup menu button to select color scheme.
    return PopupMenuButton<int>(
      padding: EdgeInsets.zero,
      onSelected: (val) {
        Prefs.themeIndex = val;
        final localeProvider =
            Provider.of<ThemeChangeNotifier>(context, listen: false);
        localeProvider.themeIndex = val;
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
        for (int i = 0; i < myFlexSchemes.length; i++)
          PopupMenuItem<int>(
            value: i,
            child: ListTile(
              leading: Icon(Icons.lens,
                  color: isLight
                      ? myFlexSchemes[i].light.primary
                      : myFlexSchemes[i].dark.primary,
                  size: 35),
              title: Text(myFlexSchemes[i].name),
            ),
          )
      ],
      child:
          /* ListTile(
        //title: Text('${myFlexSchemes[Prefs.themeIndex].name} theme'),
        //subtitle: Text(myFlexSchemes[Prefs.themeIndex].description),
        trailing:*/
          Icon(
        Icons.lens,
        color: colorScheme.primary,
        size: 26,
      ),
      //),
    );
    // pupupmenu
  }
}
