import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:tipitaka_pali/business_logic/view_models/recent_page_view_model.dart';
import 'package:tipitaka_pali/ui/dialogs/confirm_dialog.dart';
import 'package:tipitaka_pali/ui/screens/home/widgets/recent_list_tile.dart';

class RecentPage extends StatefulWidget {
  @override
  _RecentPageState createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecentPageViewModel>(
      create: (context) {
        RecentPageViewModel vm = RecentPageViewModel();
        vm.fetchRecents();
        return vm;
      },
      child: Scaffold(
        appBar: BaseAppBar(),
        body: Consumer<RecentPageViewModel>(builder: (context, vm, child) {
          return vm.recents.isEmpty
              ? Center(child: Text('ဖတ်ဆဲစာအုပ်များ မရှိပါ'))
              : ListView.separated(
                  itemCount: vm.recents.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: RecentListTile(vm, index),
                      onTap: () => vm.openBook(vm.recents[index], context),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.grey,
                    );
                  });
        }),
      ),
    );
  }
}

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RecentPageViewModel>(context, listen: false);
    return AppBar(
      title: Text('ဖတ်ဆဲကျမ်းစာများ'),
      actions: [
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final action = await _getConfirmataion(context);
              if (action == OkCancelAction.OK) {
                vm.deleteAll();
              }
            })
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);

  Future<OkCancelAction?> _getConfirmataion(BuildContext context) async {
    return await showCupertinoDialog<OkCancelAction>(
        context: context,
        builder: (context) {
          return ThemeConsumer(
              child: ConfirmDialog(
            title: 'Comfirmation',
            message: 'ဖတ်လက်စစာအုပ်စာရင်း အားလုံးကို ဖျက်ရန် သေချာပြီလား',
            cancelLabel: 'မဖျက်တော့ဘူး',
            okLabel: 'ဖျက်မယ်',
          ));
        });
  }
}
