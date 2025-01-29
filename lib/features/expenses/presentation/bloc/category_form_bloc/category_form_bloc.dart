import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'category_form_event.dart';
part 'category_form_state.dart';

class CategoryFormBloc extends Bloc<CategoryFormEvent, CategoryFormState> {
  CategoryFormBloc() : super(CategoryFormState()) {
    on<SubmitCategoryForm>((event, emit) => emit(CategoryFormState()));
    on<NameChanged>(_onNameChanged);
    on<IconSelected>(_onIconSelected);
    on<ColorSelected>(_onColorSelected);
  }

  void _onNameChanged(
      NameChanged event, Emitter<CategoryFormState> emit) async {
    emit(state.copyWith(
      name: event.name,
    ));
  }

  void _onIconSelected(
      IconSelected event, Emitter<CategoryFormState> emit) async {
    emit(state.copyWith(
      icon: event.selectedIcon,
    ));
  }

  void _onColorSelected(
      ColorSelected event, Emitter<CategoryFormState> emit) async {
    emit(state.copyWith(
      color: event.selectedColor,
    ));
  }
}
