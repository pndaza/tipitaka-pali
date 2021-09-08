import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tipitaka_pali/business_logic/view_models/bookmark_page_view_model.dart';
import 'package:tipitaka_pali/ui/dialogs/confirm_dialog.dart';
import 'package:tipitaka_pali/ui/screens/home/widgets/bookmark_list_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// enum OkCancelAction { OK, CANCEL }

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookmarkPageViewModel>(
      create: (context) {
        BookmarkPageViewModel vm = BookmarkPageViewModel();
        vm.fetchBookmarks();
        return vm;
      },
      child: Scaffold(
        appBar: BaseAppBar(),
        body: Consumer<BookmarkPageViewModel>(
          builder: (context, vm, child) {
            return vm.bookmarks.isEmpty
                ? Center(child: Text(AppLocalizations.of(context)!.bookmark))
                : ListView.separated(
                    itemCount: vm.bookmarks.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: BookmarkListTile(
                            bookmarkViewmodel: vm, index: index),
                        onTap: () => vm.openBook(vm.bookmarks[index], context),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Colors.grey,
                      );
                    });
          },
        ),
      ),
    );
  }
}

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BookmarkPageViewModel>(context, listen: false);
    return AppBar(
      title: Text(AppLocalizations.of(context)!.bookmark),
      actions: [
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              final result = await _getConfirmataion(context);
              if (result == OkCancelAction.OK) {
                vm.deleteAll();
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
          return 
 ConfirmDialog(
              title: 'Comfirmation',
              message: 'မှတ်သားထားသမျှ အားလုံးကို ဖျက်ရန် သေချာပြီလား',
              okLabel: 'ဖျက်မယ်',
              cancelLabel: 'မဖျက်တော့ဘူး',
            );
          
        });
  }
}
