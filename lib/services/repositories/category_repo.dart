import 'package:tipitaka_pali/business_logic/models/category.dart';
import 'package:tipitaka_pali/services/dao/catergory_dao.dart';
import 'package:tipitaka_pali/services/database/database_provider.dart';

abstract class CategoryRepository {
  DatabaseProvider databaseProvider;
  Future<List<Category>> getCategories(String basket);
}

class CategoryDatabaseRepository implements CategoryRepository {
  final dao = CategoryDao();
  @override
  DatabaseProvider databaseProvider;
  CategoryDatabaseRepository(this.databaseProvider);

  @override
  Future<List<Category>> getCategories(String basket) async {
    if (basket != 'annya') {
      basket = 'tri';
    }
    final db = await databaseProvider.database;
    List<Map> maps = await db.query(dao.tableName,
        columns: [dao.columnID, dao.columnName],
        where: '${dao.columnBasket} = ?',
        whereArgs: [basket]);
    return dao.fromList(maps);
  }
}
