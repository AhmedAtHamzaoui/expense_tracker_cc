import 'package:expense_tracker_cc/core/error/failures.dart';
import 'package:expense_tracker_cc/features/expenses/domain/entities/category.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class CategoriesRepository {
  Future<Either<Failure, List<Category>>> getCategories();

  Either<Failure, Unit> uploadCategory(
      {required String name, required IconData icon, required Color color});
}
