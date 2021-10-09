import 'package:tipitaka_pali/business_logic/models/toc.dart';
import 'package:tipitaka_pali/business_logic/models/toc_list_item.dart';
import 'package:tipitaka_pali/services/database/database_helper.dart';
import 'package:tipitaka_pali/services/repositories/toc_repo.dart';

class TocViewModel {
  final String bookID;
  List<TocListItem>? listItems;

  TocViewModel(this.bookID);

  Future<List<TocListItem>> fetchTocListItems() async {
    final tocs = await _fetchToc();
    return _fromList(tocs);
  }

  Future<List<Toc>> _fetchToc() async {
    final DatabaseHelper databaseProvider = DatabaseHelper();
    final TocRepository tocRepository = TocDatabaseRepository(databaseProvider);
    return await tocRepository.getTocs(bookID);
  }

  List<TocListItem> _fromList(List<Toc> tocs) {
    List<TocListItem> listItems = [];
    for (var toc in tocs) {
      switch (toc.type) {
        case "chapter":
          listItems.add(TocHeadingOne(toc));
          break;
        case "title":
          listItems.add(TocHeadingTwo(toc));
          break;
        case "subhead":
          listItems.add(TocHeadingThree(toc));
          break;
        case "subsubhead":
          listItems.add(TocHeadingFour(toc));
          break;
        default:
          listItems.add(TocHeadingOne(toc));
          break;
      }
    }
    return listItems;
  }
}
