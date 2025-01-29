import 'package:expense_tracker_cc/core/error/failures.dart';
import 'package:expense_tracker_cc/core/usecase/usecase.dart';
import 'package:expense_tracker_cc/features/expenses/domain/entities/category.dart';
import 'package:expense_tracker_cc/features/expenses/domain/repositories/categories_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllCategories implements UseCase<List<Category>, NoParams> {
  final CategoriesRepository categoriesRepository;
  GetAllCategories(this.categoriesRepository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params) {
    return Future.value(categoriesRepository.getCategories());
  }
}
