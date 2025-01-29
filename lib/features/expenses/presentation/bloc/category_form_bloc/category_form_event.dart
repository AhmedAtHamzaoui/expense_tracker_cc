part of 'category_form_bloc.dart';

@immutable
sealed class CategoryFormEvent {}

final class SubmitCategoryForm extends CategoryFormEvent {
  SubmitCategoryForm();
}

class NameChanged extends CategoryFormEvent {
  final String name;
  NameChanged(this.name);
}

class IconSelected extends CategoryFormEvent {
  final IconData selectedIcon;
  IconSelected(this.selectedIcon);
}

class ColorSelected extends CategoryFormEvent {
  final Color selectedColor;
  ColorSelected(this.selectedColor);
}
