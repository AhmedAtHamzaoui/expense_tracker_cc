import 'package:expense_tracker_cc/features/expenses/domain/entities/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'expense_form_event.dart';
part 'expense_form_state.dart';

class ExpenseFormBloc extends Bloc<ExpenseFormEvent, ExpenseFormState> {
  ExpenseFormBloc() : super(ExpenseFormState()) {
    on<DescriptionChanged>(_onDescriptionChanged);
    on<AmountChanged>(_onAmountChanged);
    on<DateSelected>(_onDateSelected);
    on<CategorySelected>(_onCategorySelected);
    on<SubmitExpenseForm>((event, emit) => emit(ExpenseFormState()));
  }

  void _onDescriptionChanged(
      DescriptionChanged event, Emitter<ExpenseFormState> emit) async {
    emit(state.copyWith(
      description: event.description,
    ));
  }

  void _onAmountChanged(
      AmountChanged event, Emitter<ExpenseFormState> emit) async {
    emit(state.copyWith(
      amount: event.amount,
    ));
  }

  void _onDateSelected(
      DateSelected event, Emitter<ExpenseFormState> emit) async {
    emit(state.copyWith(
      selectedDate: event.selectedDate,
    ));
  }

  void _onCategorySelected(
      CategorySelected event, Emitter<ExpenseFormState> emit) async {
    emit(state.copyWith(
      selectedCategory: event.selectedCategory,
    ));
  }
}
