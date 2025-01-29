import 'package:drift/native.dart';
import 'package:expense_tracker_cc/core/converters/converters.dart';
import 'package:expense_tracker_cc/core/error/exceptions.dart';
import 'package:expense_tracker_cc/features/expenses/data/datasources/local/app_db.dart';
import 'package:expense_tracker_cc/features/expenses/data/models/category_model.dart';

abstract interface class CategoryLocalDataSource {
  Future<void> uploadLocalCategory({required CategoryModel category});
  Future<List<CategoryModel>> loadCategories();
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final CategoryDao _dao;
  CategoryLocalDataSourceImpl(this._dao);

  @override
  Future<List<CategoryModel>> loadCategories() async {
    try {
      final categoriesList = <CategoryModel>[];
      var categoriesDT = await _dao.selectAllCategories();
      for (var item in categoriesDT) {
        categoriesList.add(dataCategoryConverter(item));
      }
      return categoriesList;
    } on SqliteException catch (e) {
      throw LocalDatabaseException(e);
    }
  }

  @override
  Future<void> uploadLocalCategory({required CategoryModel category}) async {
    try {
      await _dao.insertCategory(categoryDataConverter(category));
    } on SqliteException catch (e) {
      throw LocalDatabaseException(e);
    }
  }
}
