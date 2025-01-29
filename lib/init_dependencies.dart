import 'package:expense_tracker_cc/features/expenses/data/datasources/local/app_db.dart';
import 'package:expense_tracker_cc/features/expenses/data/datasources/local/category_local_data_source.dart';
import 'package:expense_tracker_cc/features/expenses/data/datasources/local/expense_local_data_source.dart';
import 'package:expense_tracker_cc/features/expenses/data/repositories/categories_repository_impl.dart';
import 'package:expense_tracker_cc/features/expenses/data/repositories/expenses_repository_impl.dart';
import 'package:expense_tracker_cc/features/expenses/domain/repositories/categories_repository.dart';
import 'package:expense_tracker_cc/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:expense_tracker_cc/features/expenses/domain/usecases/get_all_expenses.dart';
import 'package:expense_tracker_cc/features/expenses/domain/usecases/get_categories.dart';
import 'package:expense_tracker_cc/features/expenses/domain/usecases/upload_category.dart';
import 'package:expense_tracker_cc/features/expenses/domain/usecases/upload_expense.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/bloc/category/category_bloc.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/bloc/category_form_bloc/category_form_bloc.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/bloc/expense/expense_bloc.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/bloc/expense_form/expense_form_bloc.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependecies() async {
  _initExpenses();

  // Register Drift
  //serviceLocator.registerSingleton<ExpensesDatabase>(ExpensesDatabase());
}

void _initExpenses() {
  // Datasource
  serviceLocator
    ..registerSingleton<ExpensesDatabase>(ExpensesDatabase())
    ..registerSingleton<ExpenseDao>(ExpenseDao(serviceLocator()))
    ..registerSingleton<CategoryDao>(CategoryDao(serviceLocator()))
    ..registerFactory<ExpenseLocalDataSource>(
      () => ExpenseLocalDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<CategoryLocalDataSource>(
      () => CategoryLocalDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<ExpensesRepository>(
      () => ExpensesRepositoryImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<CategoriesRepository>(
      () => CategoriesRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UploadExpense(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllExpenses(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllCategories(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UploadCategory(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(() => ExpenseBloc(
          uploadExpense: serviceLocator(),
          getAllExpenses: serviceLocator(),
          getAllCategories: serviceLocator(),
        ))
    ..registerLazySingleton(() => CategoryBloc(
          getAllCategories: serviceLocator(),
          uploadCategory: serviceLocator(),
        ))
    ..registerLazySingleton(() => ExpenseFormBloc())
    ..registerLazySingleton(() => CategoryFormBloc())
    ..registerLazySingleton(() => NavigationBloc());
}
