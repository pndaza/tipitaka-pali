import 'package:flutter/material.dart';
// #docregion AppLocalizationsImport
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tipitaka_pali/business_logic/models/list_item.dart';
import 'package:tipitaka_pali/business_logic/view_models/home_page_view_model.dart';

// #enddocregion AppLocalizationsImport

import '../../../routes.dart';

class HomePage extends StatelessWidget {
  final List<String> mainCategories = [
    'mula',
    'attha',
    'tika',
    'annya',
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.tipitaka_pali_reader),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () => _openSettingPage(context),
              ),
              IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () => _showAboutDialog(context))
            ],
            bottom: TabBar(
              tabs: mainCategories
                  .map((category) => Tab(text: category))
                  .toList(),
            ),
          ),
          body: TabBarView(
              children: mainCategories
                  .map((category) => _buildBookList(category))
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
        applicationName: 'တိပိဋကပါဠိ',
        applicationVersion: 'ဗားရှင်း။ ။ ၁.၀.၀',
        children: [
          Text('''
                ကျမ်းစာများ
          ပါဠိ၊ အဋ္ဌကထာ၊ ဋီကာ နှင့် အခြား ပိဋကတ်ဆိုင်ရာ ကျမ်းစာများ ပါဝင်ပါသည်။

                စာရှာ
          ယူနီကုဒ်အသုံးပြု၍ ရှာနိုင်ပါသည်။ ( ဇော်ဂျီဖြင့် မရပါ။ )
          ပုဒ်တပုဒ်တည်းသာ မကဘဲ နှစ်ပုဒ်တွဲအားဖြင့်လည်း ရှာနိုင်ပါသည်။ (သုံးပုဒ်တွဲနှင့်အထက် မရသေးပါ။)
          တပုဒ်တည်း ရှာဖွေရာအခါ၌ လမ်းညွှန်ပုဒ်များ ( suggestion words ) ကို ပြသပေးပါလိမ့်မည်။

              အဘိဓာန်ကြည့်
          စကားလုံးပေါ်ထောက်၍ အဘိဓာန်ကြည့်ရှုနိုင်ပါသည်။
          ပကတိပုဒ်ရင်းကို အမှန်အတိုင်း မှန်းမဆရ၍ မှားယွင်းစွာ ပြသနေပါက တည်ပုဒ်ကို ကိုယ်တိုင် ပြင်ဆင်၍ ကြည့်ရှုနိုင်ပါသည်။
          ''')
        ]);
  }
}
