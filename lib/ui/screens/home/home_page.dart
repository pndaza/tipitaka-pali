import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tipitaka_pali/business_logic/models/list_item.dart';
import 'package:tipitaka_pali/business_logic/view_models/home_page_view_model.dart';

import '../../../routes.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            title: Center(child: Text('တိပိဋကပါဠိ')),
            actions: [
              IconButton(
                  icon: Icon(Icons.palette),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (_) => ThemeConsumer(
                              child: ThemeDialog(
                            hasDescription: false,
                          )))),
              IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                    _showAboutDialog(context);
                  })
            ],
            bottom: TabBar(
              tabs: [
                Tab(text: 'ပါဠိ'),
                Tab(text: 'အဋ္ဌကထာ'),
                Tab(text: 'ဋီကာ'),
                Tab(text: 'အည'),
              ],
            ),
          ),
          body: FutureBuilder(
            future: buildTabBarView(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
              if (snapshot.hasData) {
                return TabBarView(children: snapshot.data!);
              }
              return Container();
            },
          )),
    );
  }

  Future<List<Widget>> buildTabBarView() async {
    List<String> mainCategories = [
      'mula',
      'attha',
      'tika',
      'annya',
    ];
    List<Widget> views = [];
    for (final category in mainCategories) {
      final listItems = await HomePageViewModel().fecthItems(category);

      final listView = ListView.separated(
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

      views.add(listView);
    }
    return views;
  }

  _openBook(BuildContext context, ListItem listItem) {
    if (listItem.runtimeType == BookItem) {
      BookItem bookItem = listItem as BookItem;
      debugPrint('book name: ${bookItem.book.name}');
      Navigator.pushNamed(context, ReaderRoute,
          arguments: {'book': bookItem.book});
    }
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
