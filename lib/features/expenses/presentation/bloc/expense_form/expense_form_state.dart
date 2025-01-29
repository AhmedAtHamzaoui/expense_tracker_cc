part of 'expense_form_bloc.dart';

final class ExpenseFormState {
  final String description;
  final double? amount;
  final DateTime? selectedDate;
  final Category? selectedCategory;

  ExpenseFormState(
      {this.description = '',
      this.amount,
      this.selectedDate,
      this.selectedCategory});

  /// Copy method for updating state immutably
  ExpenseFormState copyWith(
      {String? title,
      String? description,
      double? amount,
      DateTime? selectedDate,
      Category? selectedCategory}) {
    return ExpenseFormState(
        description: description ?? this.description,
        amount: amount ?? this.amount,
        selectedDate: selectedDate ?? this.selectedDate,
        selectedCategory: selectedCategory ?? this.selectedCategory);
  }
}
