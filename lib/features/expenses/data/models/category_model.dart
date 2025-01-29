import 'package:expense_tracker_cc/features/expenses/domain/entities/category.dart';
import 'package:flutter/material.dart';

class CategoryModel extends Category {
  CategoryModel(
      {required super.id,
      required super.name,
      required super.icon,
      required super.color});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'icon': icon,
      'color': color
    };
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        id: json['id'],
        name: json['name'],
        icon: json['icon'],
        color: json['color']);
  }

  CategoryModel copyWith({
    int? id,
    String? name,
    IconData? icon,
    Color? color,
  }) {
    return CategoryModel(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        color: color ?? this.color);
  }
}
