import 'package:expense_tracker_cc/core/error/exceptions.dart';
import 'package:expense_tracker_cc/core/error/failures.dart';
import 'package:expense_tracker_cc/features/expenses/data/datasources/local/category_local_data_source.dart';
import 'package:expense_tracker_cc/features/expenses/data/models/category_model.dart';
import 'package:expense_tracker_cc/features/expenses/domain/entities/category.dart';
import 'package:expense_tracker_cc/features/expenses/domain/repositories/categories_repository.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CategoryLocalDataSource categoryLocalDataSource;

  CategoriesRepositoryImpl(this.categoryLocalDataSource);

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categories = await categoryLocalDataSource.loadCategories();
      return right(categories);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Either<Failure, Unit> uploadCategory(
      {required String name, required IconData icon, required Color color}) {
    try {
      categoryLocalDataSource.uploadLocalCategory(
          category: CategoryModel(id: 0, name: name, icon: icon, color: color));
      return right(unit);
    } on LocalDatabaseException catch (e) {
      return left(Failure(e.message));
    }
  }
}
