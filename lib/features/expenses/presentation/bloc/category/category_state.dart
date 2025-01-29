part of 'category_bloc.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategoryFailure extends CategoryState {
  final String error;
  CategoryFailure(this.error);
}

final class CategoryUploadSuccess extends CategoryState {}

final class CategoriesDisplaySuccess extends CategoryState {
  final List<Category> categories;
  CategoriesDisplaySuccess({required this.categories});
}
