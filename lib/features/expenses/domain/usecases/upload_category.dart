import 'package:expense_tracker_cc/core/error/failures.dart';
import 'package:expense_tracker_cc/core/usecase/usecase.dart';
import 'package:expense_tracker_cc/features/expenses/domain/repositories/categories_repository.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class UploadCategory implements UseCase<Unit, UploadCategoryParams> {
  final CategoriesRepository categoriesRepository;
  UploadCategory(this.categoriesRepository);
  @override
  Future<Either<Failure, Unit>> call(params) {
    return Future.value(categoriesRepository.uploadCategory(
        name: params.name, icon: params.icon, color: params.color));
  }
}

class UploadCategoryParams {
  final String name;
  final IconData icon;
  final Color color;

  UploadCategoryParams(
      {required this.name, required this.icon, required this.color});
}
