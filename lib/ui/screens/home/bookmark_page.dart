import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../business_logic/view_models/bookmark_page_view_model.dart';
import '../../../services/dao/bookmark_dao.dart';
import '../../../services/database/database_helper.dart';
import '../../../services/repositories/bookmark_repo.dart';
import '../../dialogs/confirm_dialog.dart';
import 'widgets/bookmark_list_tile.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookmarkPageViewModel>(
      create: (_) =>
          BookmarkPageViewModel(BookmarkDatabaseRepository(DatabaseHelper(), BookmarkDao()))
            ..fetchBookmarks(),
      child: Scaffold(
        appBar: const BookmarkAppBar(),
        body: Consumer<BookmarkPageViewModel>(
          builder: (context, vm, child) {
            final bookmarks = vm.bookmarks;
            return bookmarks.isEmpty
                ? Center(child: Text(AppLocalizations.of(context)!.bookmark))
                : ListView.separated(
                    itemCount: bookmarks.length,
                    itemBuilder: (context, index) {
                      final bookmark = bookmarks[index];
                      return BookmarkListTile(
                        bookmark: bookmark,
                        onTap: (bookmark) => vm.openBook(bookmark, context),
                        onDelete: (bookmark) => vm.delete(bookmark),
                      );
                    },
                    separatorBuilder: (_, __) {
                      return const Divider(color: Colors.grey);
                    });
          },
        ),
      ),
    );
  }
}

class BookmarkAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BookmarkAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.bookmark),
      actions: [
        IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final result = await _getConfirmataion(context);
              if (result == OkCancelAction.OK) {
                context.read<BookmarkPageViewModel>().deleteAll();
              }
            })
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  Future<OkCancelAction?> _getConfirmataion(BuildContext context) async {
    return await showDialog<OkCancelAction>(
        context: context,
        builder: (context) {
          return const ConfirmDialog(
            title: 'Comfirmation',
            message: 'မှတ်သားထားသမျှ အားလုံးကို ဖျက်ရန် သေချာပြီလား',
            okLabel: 'ဖျက်မယ်',
            cancelLabel: 'မဖျက်တော့ဘူး',
          );
        });
  }
}
