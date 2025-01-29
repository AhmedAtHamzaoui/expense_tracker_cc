part of 'expense_bloc.dart';

@immutable
sealed class ExpenseState {}

final class ExpenseInitial extends ExpenseState {}

final class ExpenseLoading extends ExpenseState {}

final class ExpenseFailure extends ExpenseState {
  final String error;
  ExpenseFailure(this.error);
}

final class ExpenseUploadSuccess extends ExpenseState {}

final class ExpensesDisplaySuccess extends ExpenseState {
  final List<Expense> expenses;
  final List<Category> categories;
  ExpensesDisplaySuccess(this.expenses, this.categories);
}
