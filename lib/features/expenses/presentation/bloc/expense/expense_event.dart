part of 'expense_bloc.dart';

@immutable
sealed class ExpenseEvent {}

final class ExpenseUploadEvent extends ExpenseEvent {
  final Expense expense;
  ExpenseUploadEvent({required this.expense});
}

final class ExpenseFetchAll extends ExpenseEvent {}
