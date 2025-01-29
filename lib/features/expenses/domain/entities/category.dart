import 'package:flutter/material.dart';

class Category {
  final int? id;
  final String name;
  final IconData icon;
  final Color color;

  const Category({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}
