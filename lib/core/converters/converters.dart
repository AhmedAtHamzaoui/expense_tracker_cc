import 'package:expense_tracker_cc/features/expenses/data/datasources/local/app_db.dart';
import 'package:expense_tracker_cc/features/expenses/data/models/category_model.dart';
import 'package:expense_tracker_cc/features/expenses/data/models/expense_model.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

/// Converts ExpenseModel object to Data object
Insertable<ExpenseTableData> expenseDataConverter(ExpenseModel expenseModel) {
  return ExpenseTableCompanion.insert(
    amount: expenseModel.amount,
    categoryId: expenseModel.categoryId,
    date: expenseModel.date,
    description: expenseModel.description,
  );
}

/// Converts AppExpenseData object to ExpenseModel object
ExpenseModel dataExpenseConverter(ExpenseTableData expenseTableData) {
  return ExpenseModel(
    id: expenseTableData.id,
    amount: expenseTableData.amount,
    categoryId: expenseTableData.categoryId,
    date: expenseTableData.date,
    description: expenseTableData.description,
  );
}

/// Converts CategoryModel object to Data object
Insertable<CategoryTableData> categoryDataConverter(
    CategoryModel categoryModel) {
  return CategoryTableCompanion.insert(
    name: categoryModel.name,
    color: categoryModel.color.value,
    iconCode: categoryModel.icon.codePoint,
  );
}

/// Converts AppCategoryData object to CategoryModel object
CategoryModel dataCategoryConverter(CategoryTableData categoryTableData) {
  return CategoryModel(
    id: categoryTableData.id,
    name: categoryTableData.name,
    color: Color(categoryTableData.color),
    icon: IconData(categoryTableData.iconCode, fontFamily: 'MaterialIcons'),
  );
}
