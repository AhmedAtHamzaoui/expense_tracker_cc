part of 'category_bloc.dart';

@immutable
sealed class CategoryEvent {}

final class CategoryUploadEvent extends CategoryEvent {
  final Category category;
  CategoryUploadEvent({required this.category});
}

final class CategoryFetchAll extends CategoryEvent {}
