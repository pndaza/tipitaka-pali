import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tipitaka_pali/business_logic/models/book.dart';
import 'package:tipitaka_pali/business_logic/models/bookmark.dart';
import 'package:tipitaka_pali/business_logic/view_models/bookmark_page_view_model.dart';
import '../../../../routes.dart';

class BookmarkListTile extends StatelessWidget {
  final BookmarkPageViewModel bookmarkViewmodel;
  final int index;

  const BookmarkListTile({Key? key, required this.bookmarkViewmodel, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookmark = bookmarkViewmodel.bookmarks[index];
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: [
        IconSlideAction(
          icon: Icons.delete,
          color: Colors.red,
          onTap: () {
            bookmarkViewmodel.delete(index);
          },
        )
      ],
      child: GestureDetector(
        child: ListTile(
          title: Text(bookmark.note),
          subtitle: Text(bookmark.bookName!),
          trailing: Container(
            width: 80,
            child: Row(
              children: [
                Text('page  - '),
                Expanded(
                    child: Text(
                  '${bookmark.pageNumber}',
                  textAlign: TextAlign.end,
                )),
              ],
            ),
          ),
        ),
        onTap: () {
          _openBook(context, bookmark);
        },
      ),
    );
  }

  _openBook(BuildContext context, Bookmark bookmark) {
    Navigator.pushNamed(context, ReaderRoute, arguments: {
      'book': Book(id: bookmark.bookID, name: bookmark.bookName!),
      'currentPage': bookmark.pageNumber
    });
  }
}
