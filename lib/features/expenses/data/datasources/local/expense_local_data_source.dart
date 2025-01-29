import 'package:drift/native.dart';
import 'package:expense_tracker_cc/core/converters/converters.dart';
import 'package:expense_tracker_cc/core/error/exceptions.dart';
import 'package:expense_tracker_cc/features/expenses/data/datasources/local/app_db.dart';
import 'package:expense_tracker_cc/features/expenses/data/models/expense_model.dart';

abstract interface class ExpenseLocalDataSource {
  Future<void> uploadLocalExpense({required ExpenseModel expense});
  Future<List<ExpenseModel>> loadExpenses();
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final ExpenseDao _dao;
  ExpenseLocalDataSourceImpl(this._dao);

  @override
  Future<List<ExpenseModel>> loadExpenses() async {
    try {
      final expenses = <ExpenseModel>[];
      var expensesDT = await _dao.selectAllExpenses();
      for (var item in expensesDT) {
        expenses.add(dataExpenseConverter(item));
      }
      return expenses;
    } on SqliteException catch (e) {
      throw LocalDatabaseException(e);
    }
  }

  @override
  Future<void> uploadLocalExpense({required ExpenseModel expense}) async {
    try {
      await _dao.insertExpense(expenseDataConverter(expense));
    } on SqliteException catch (e) {
      throw LocalDatabaseException(e);
    }
  }
}
