import 'package:flutter/material.dart';
// #docregion AppLocalizationsImport
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tipitaka_pali/business_logic/models/list_item.dart';
import 'package:tipitaka_pali/business_logic/view_models/home_page_view_model.dart';
import 'package:tipitaka_pali/ui/widgets/select_language_widget.dart';
import 'package:tipitaka_pali/ui/widgets/select_theme_widget.dart';
import 'package:tipitaka_pali/ui/widgets/colored_text.dart';

// #enddocregion AppLocalizationsImport

import '../../../routes.dart';

class HomePage extends StatelessWidget {
  // key will be use for load book list from database
  // value will be use for TabBar Title
  final Map<String, String> _mainCategories = {
    'mula': 'Pāḷi',
    'attha': 'Aṭṭhakathā',
    'tika': 'Ṭīkā',
    'annya': 'Añña'
  };

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.tipitaka_pali_reader),
            centerTitle: true,
            actions: [],
            bottom: TabBar(
              tabs: _mainCategories.entries
                  .map((category) => Tab(text: category.value))
                  .toList(),
            ),
          ),
          drawer: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(),
                  child: Column(
                    children: [
                      ColoredText(
                          AppLocalizations.of(context)!.tipitaka_pali_reader,
                          style: TextStyle(
                            fontSize: 17,
                          )),
                      SizedBox(height: 15.0),
                      Image.asset(
                        "assets/icon/icon.png",
                        height: 60,
                        width: 60,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: ColoredText(AppLocalizations.of(context)!.about,
                      style: TextStyle()),
                  onTap: () {
                    _showAboutDialog(context);
                  },
                ),
                ListTile(
                  title: ColoredText(AppLocalizations.of(context)!.settings,
                      style: TextStyle()),
                  onTap: () {
                    _openSettingPage(context);
                    ;
                  },
                ),
              ],
            ),
          ),
          body: TabBarView(
              children: _mainCategories.entries
                  .map((category) => _buildBookList(category.key))
                  .toList())),
    );
  }

  Widget _buildBookList(String category) {
    return FutureBuilder(
        future: _loadBooks(category),
        builder: (context, AsyncSnapshot<List<ListItem>> snapshot) {
          if (snapshot.hasData) {
            final listItems = snapshot.data!;
            return ListView.separated(
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: ListTile(
                      title: listItems[index].build(context),
                    ),
                    onTap: () => _openBook(context, listItems[index]),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.grey,
                  );
                });
          }
          // will be dispaly blank while loading instead of circular progress indicator
          return Container();
        });
  }

  Future<List<ListItem>> _loadBooks(String category) async {
    return await HomePageViewModel().fecthItems(category);
  }

  _openBook(BuildContext context, ListItem listItem) {
    if (listItem.runtimeType == BookItem) {
      BookItem bookItem = listItem as BookItem;
      debugPrint('book name: ${bookItem.book.name}');
      Navigator.pushNamed(context, ReaderRoute,
          arguments: {'book': bookItem.book});
    }
  }

  _openSettingPage(BuildContext context) {
    Navigator.pushNamed(context, SettingRoute);
  }

  _showAboutDialog(BuildContext context) {
    showAboutDialog(
        context: context,
        applicationName: AppLocalizations.of(context)!.tipitaka_pali_reader,
        applicationVersion: 'ဗားရှင်း။ ။ ၁.၀.၀',
        children: [ColoredText(AppLocalizations.of(context)!.about_info)]);
  }

  _showLanguageAndThemeSettingsDialog(BuildContext context) {
    showAboutDialog(
        context: context,
        applicationName: 'Set Theme Color and Language ',
        applicationVersion: 'new',
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColoredText("Theme:"),
                  SizedBox(
                    width: 30,
                  ),
                  SelectThemeWidget(),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              SelectLanguageWidget(),
            ],
          ),
        ]);
  }
}
