import 'package:expense_tracker_cc/core/error/failures.dart';
import 'package:expense_tracker_cc/core/usecase/usecase.dart';
import 'package:expense_tracker_cc/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadExpense implements UseCase<Unit, UploadExpenseParams> {
  final ExpensesRepository expensesRepository;
  UploadExpense(this.expensesRepository);
  @override
  Future<Either<Failure, Unit>> call(params) {
    return Future.value(expensesRepository.uploadExpense(
        amount: params.amount,
        categoryId: params.categoryId,
        date: params.date,
        description: params.description));
  }
}

class UploadExpenseParams {
  final double amount;
  final int categoryId;
  final DateTime date;
  final String description;

  UploadExpenseParams(
      {required this.amount,
      required this.categoryId,
      required this.date,
      required this.description});
}
