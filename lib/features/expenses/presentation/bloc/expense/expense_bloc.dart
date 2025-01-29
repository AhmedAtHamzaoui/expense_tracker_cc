import 'package:expense_tracker_cc/core/usecase/usecase.dart';
import 'package:expense_tracker_cc/features/expenses/domain/entities/category.dart';
import 'package:expense_tracker_cc/features/expenses/domain/entities/expense.dart';
import 'package:expense_tracker_cc/features/expenses/domain/usecases/get_all_expenses.dart';
import 'package:expense_tracker_cc/features/expenses/domain/usecases/get_categories.dart';
import 'package:expense_tracker_cc/features/expenses/domain/usecases/upload_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final UploadExpense _uploadExpense;
  final GetAllExpenses _getAllExpenses;
  final GetAllCategories _getAllCategories;

  ExpenseBloc({
    required UploadExpense uploadExpense,
    required GetAllExpenses getAllExpenses,
    required GetAllCategories getAllCategories,
  })  : _uploadExpense = uploadExpense,
        _getAllExpenses = getAllExpenses,
        _getAllCategories = getAllCategories,
        super(ExpenseInitial()) {
    on<ExpenseEvent>((event, emit) => emit(ExpenseLoading()));
    on<ExpenseUploadEvent>(_onExpenseUpload);
    on<ExpenseFetchAll>(_onExpenseFetchAll);
  }

  void _onExpenseUpload(
      ExpenseUploadEvent event, Emitter<ExpenseState> emit) async {
    final res = await _uploadExpense(UploadExpenseParams(
      amount: event.expense.amount,
      categoryId: event.expense.categoryId,
      date: event.expense.date,
      description: event.expense.description,
    ));
    res.fold(
      (l) => emit(ExpenseFailure(l.message)),
      (r) => emit(ExpenseUploadSuccess()),
    );
  }

  void _onExpenseFetchAll(
      ExpenseFetchAll event, Emitter<ExpenseState> emit) async {
    final expRes = await _getAllExpenses(NoParams());
    final catRes = await _getAllCategories(NoParams());

    // Check for failures
    if (expRes.isLeft() || catRes.isLeft()) {
      final errorMessage = expRes.fold((l) => l.message, (r) => null) ??
          catRes.fold((l) => l.message, (r) => null);
      emit(ExpenseFailure(errorMessage ?? "Unknown error"));
      return;
    }

    // Extract successful results
    final List<Expense> expenses = expRes.fold((l) => [], (r) => r);
    final List<Category> categories = catRes.fold((l) => [], (r) => r);

    emit(ExpensesDisplaySuccess(expenses, categories));
  }
}
