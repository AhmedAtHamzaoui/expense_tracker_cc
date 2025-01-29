import 'package:expense_tracker_cc/core/usecase/usecase.dart';
import 'package:expense_tracker_cc/features/expenses/domain/entities/category.dart';
import 'package:expense_tracker_cc/features/expenses/domain/usecases/get_categories.dart';
import 'package:expense_tracker_cc/features/expenses/domain/usecases/upload_category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetAllCategories _getAllCategories;
  final UploadCategory _uploadCategory;

  CategoryBloc({
    required GetAllCategories getAllCategories,
    required UploadCategory uploadCategory,
  })  : _getAllCategories = getAllCategories,
        _uploadCategory = uploadCategory,
        super(CategoryInitial()) {
    on<CategoryEvent>((event, emit) => emit(CategoryLoading()));
    on<CategoryFetchAll>(_onCategoryFetchAll);
    on<CategoryUploadEvent>(_onCategoryUpload);
  }

  void _onCategoryFetchAll(
      CategoryFetchAll event, Emitter<CategoryState> emit) async {
    final res = await _getAllCategories(NoParams());
    res.fold(
      (l) => emit(CategoryFailure(l.message)),
      (r) {
        emit(CategoriesDisplaySuccess(categories: r));
      },
    );
  }

  void _onCategoryUpload(
      CategoryUploadEvent event, Emitter<CategoryState> emit) async {
    final res = await _uploadCategory(
      UploadCategoryParams(
        name: event.category.name,
        icon: event.category.icon,
        color: event.category.color,
      ),
    );
    res.fold(
      (l) => emit(CategoryFailure(l.message)),
      (r) => emit(CategoryUploadSuccess()),
    );
  }
}
