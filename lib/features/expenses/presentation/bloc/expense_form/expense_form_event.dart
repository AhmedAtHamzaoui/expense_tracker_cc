part of 'expense_form_bloc.dart';

@immutable
sealed class ExpenseFormEvent {}

final class SubmitExpenseForm extends ExpenseFormEvent {
  SubmitExpenseForm();
}

class DescriptionChanged extends ExpenseFormEvent {
  final String description;
  DescriptionChanged(this.description);
}

class AmountChanged extends ExpenseFormEvent {
  final double amount;
  AmountChanged(this.amount);
}

class DateSelected extends ExpenseFormEvent {
  final DateTime selectedDate;
  DateSelected(this.selectedDate);
}

class CategorySelected extends ExpenseFormEvent {
  final Category selectedCategory;
  CategorySelected(this.selectedCategory);
}
