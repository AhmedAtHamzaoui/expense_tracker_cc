import 'package:expense_tracker_cc/core/error/exceptions.dart';
import 'package:expense_tracker_cc/core/error/failures.dart';
import 'package:expense_tracker_cc/features/expenses/data/datasources/local/expense_local_data_source.dart';
import 'package:expense_tracker_cc/features/expenses/data/models/expense_model.dart';
import 'package:expense_tracker_cc/features/expenses/domain/entities/expense.dart';
import 'package:expense_tracker_cc/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:fpdart/fpdart.dart';

class ExpensesRepositoryImpl implements ExpensesRepository {
  final ExpenseLocalDataSource expenseLocalDataSource;

  ExpensesRepositoryImpl(this.expenseLocalDataSource);

  @override
  Either<Failure, Unit> uploadExpense({
    required double amount,
    required int categoryId,
    required DateTime date,
    required String description,
  }) {
    try {
      ExpenseModel expenseModel = ExpenseModel(
          id: 0,
          amount: amount,
          categoryId: categoryId,
          date: date,
          description: description);
      expenseLocalDataSource.uploadLocalExpense(expense: expenseModel);
      return right(unit);
    } on LocalDatabaseException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getExpenses() async {
    try {
      final expenses = await expenseLocalDataSource.loadExpenses();
      return right(expenses);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
