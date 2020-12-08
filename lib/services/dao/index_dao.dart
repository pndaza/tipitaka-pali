import 'package:tipitaka_pali/business_logic/models/index.dart';
import 'package:tipitaka_pali/services/dao/dao.dart';

class IndexDao implements Dao<Index> {
  final String tableWords = 'words';
  final String columnWord = 'word';
  final String columnIndex = 'indexes';

  @override
  List<Index> fromList(List<Map<String, dynamic>> querys) {
    final String rawIndexes = querys.first[columnIndex];
    final List<String> rawIndexList = rawIndexes.split(',');
    final List<Index> indexes = [];
    for (String rawIndex in rawIndexList) {
      indexes.add(_parseIndex(rawIndex));
    }
    return indexes;
  }

  @override
  Index fromMap(Map<String, dynamic> query) {
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toMap(Index object) {
    throw UnimplementedError();
  }

  Index _parseIndex(String indexString) {
    final indexInfo = indexString.split('_');
    final int page = int.parse(indexInfo[0]);
    final int position = int.parse(indexInfo[1]);
    return Index(page, position);
  }
}
