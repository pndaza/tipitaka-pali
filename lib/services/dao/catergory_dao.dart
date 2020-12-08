import 'package:tipitaka_pali/business_logic/models/category.dart';
import 'package:tipitaka_pali/services/dao/dao.dart';

class CategoryDao implements Dao<Category> {
  final String tableName = 'category';
  final String columnID = 'id';
  final String columnName = 'name';
  final String columnBasket = 'basket';
  @override
  List<Category> fromList(List<Map<String, dynamic>> query) {
    return query.map((e) => fromMap(e)).toList();
  }

  @override
  Category fromMap(Map<String, dynamic> query) {
    return Category(query[columnID], query[columnName]);
  }

  @override
  Map<String, dynamic> toMap(Category object) {
    throw UnimplementedError();
  }
}
