import 'package:expense_tracker_cc/core/error/failures.dart';
import 'package:expense_tracker_cc/features/expenses/domain/entities/expense.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ExpensesRepository {
  Future<Either<Failure, List<Expense>>> getExpenses();

  Either<Failure, Unit> uploadExpense({
    required double amount,
    required int categoryId,
    required DateTime date,
    required String description,
  });
}
