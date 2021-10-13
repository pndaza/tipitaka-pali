import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../../../business_logic/models/bookmark.dart';
import '../../../../services/provider/script_language_provider.dart';
import '../../../../utils/pali_script.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookmarkListTile extends StatelessWidget {
  // final BookmarkPageViewModel bookmarkViewmodel;
  // final int index;

  const BookmarkListTile(
      {Key? key, required this.bookmark, this.onTap, this.onDelete})
      : super(key: key);
  final Bookmark bookmark;
  final Function(Bookmark bookmark)? onDelete;
  final Function(Bookmark bookmark)? onTap;

  @override
  Widget build(BuildContext context) {
    return Slidable(
        actionPane: const SlidableDrawerActionPane(),
        secondaryActions: [
          IconSlideAction(
            icon: Icons.delete,
            color: Colors.red,
            onTap: () {
              if (onDelete != null) onDelete!(bookmark);
            },
          )
        ],
        child: Builder(
            builder: (context) => GestureDetector(
                behavior: HitTestBehavior.translucent,
                onLongPress: () {
                  openSlidable(context);
                },
                child: ListTile(
                  onTap: () {
                    if (onTap != null) onTap!(bookmark);
                  },
                  title: Text(bookmark.note),
                  subtitle: Text(PaliScript.getScriptOf(
                      language: context
                          .read<ScriptLanguageProvider>()
                          .currentLanguage,
                      romanText: bookmark.bookName!)),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        Text('${AppLocalizations.of(context)!.page} -'),
                        Expanded(
                            child: Text(
                          '${bookmark.pageNumber}',
                          textAlign: TextAlign.end,
                        )),
                      ],
                    ),
                  ),
                ))));
  }

  void openSlidable(BuildContext context) {
    final slidable = Slidable.of(context);
    final isClosed = slidable!.renderingMode == SlidableRenderingMode.none;
    if (isClosed) {
      Future.delayed(Duration.zero, () {
        if (slidable.mounted) {
          slidable.open(actionType: SlideActionType.secondary);
        }
      });
    }
  }
}
