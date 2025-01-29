part of 'category_form_bloc.dart';

final class CategoryFormState {
  final String name;
  final Color? color;
  final IconData? icon;

  CategoryFormState(
      {this.name = '', this.color = Colors.red, this.icon = Icons.wallet});

  /// Copy method for updating state immutably
  CategoryFormState copyWith({String? name, Color? color, IconData? icon}) {
    return CategoryFormState(
        name: name ?? this.name,
        color: color ?? this.color,
        icon: icon ?? this.icon);
  }
}
