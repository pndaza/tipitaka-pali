import 'package:flutter/material.dart';
import 'package:tipitaka_pali/business_logic/models/toc_list_item.dart';
import 'package:tipitaka_pali/business_logic/view_models/toc_view_model.dart';

class TocDialog extends StatelessWidget {
  final String bookID;
  TocDialog(this.bookID);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(alignment: Alignment.center, children: [
            Text(
              'မာတိကာ',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ))
          ]),
          Divider(),
          FutureBuilder<List<TocListItem>>(
              future: TocViewModel(bookID).fetchTocListItems(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final listItems = snapshot.data!;
                  return Expanded(
                    child: ListView.separated(
                      itemCount: listItems.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            final pageNumber = listItems[index].getPageNumber();
                            Navigator.pop(context, pageNumber);
                          },
                          child: ListTile(
                            title: listItems[index].build(context),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                            height: 1, indent: 16.0, endIndent: 16.0);
                      },
                    ),
                  );
                } else {
                  return Container(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ],
      ),
    );
  }
}
