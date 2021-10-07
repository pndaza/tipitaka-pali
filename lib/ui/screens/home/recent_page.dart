import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../business_logic/view_models/recent_page_view_model.dart';
import '../../../services/dao/recent_dao.dart';
import '../../../services/database/database_helper.dart';
import '../../../services/repositories/recent_repo.dart';
import '../../dialogs/confirm_dialog.dart';
import 'widgets/recent_list_tile.dart';

class RecentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecentPageViewModel>(
      create: (_) =>
          RecentPageViewModel(RecentDatabaseRepository(DatabaseHelper(), RecentDao()))
            ..fetchRecents(),
      child: Scaffold(
        appBar: RecentAppBar(),
        body: Consumer<RecentPageViewModel>(builder: (context, vm, child) {
          final recents = vm.recents;
          return recents.isEmpty
              ? Center(child: Text(AppLocalizations.of(context)!.recent))
              : ListView.separated(
                  itemCount: recents.length,
                  itemBuilder: (context, index) {
                    final recent = recents[index];
                    return RecentListTile(
                      recent: recent,
                      onTap: (recent) => vm.openBook(recent, context),
                      onDelete: (recent) => vm.delete(recent),
                    );
                  },
                  separatorBuilder: (_, __) {
                    return Divider(color: Colors.grey);
                  });
        }),
      ),
    );
  }
}

class RecentAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RecentAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.recent),
      actions: [
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final action = await _getConfirmataion(context);
              if (action == OkCancelAction.OK) {
                context.read<RecentPageViewModel>().deleteAll();
              }
            })
      ],
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);

  Future<OkCancelAction?> _getConfirmataion(BuildContext context) async {
    return await showDialog<OkCancelAction>(
        context: context,
        builder: (context) {
          return ConfirmDialog(
            title: 'Comfirmation',
            message: 'ဖတ်လက်စစာအုပ်စာရင်း အားလုံးကို ဖျက်ရန် သေချာပြီလား',
            cancelLabel: 'မဖျက်တော့ဘူး',
            okLabel: 'ဖျက်မယ်',
          );
        });
  }
}
