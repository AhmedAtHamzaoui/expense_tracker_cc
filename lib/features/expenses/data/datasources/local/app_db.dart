import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:expense_tracker_cc/features/expenses/data/datasources/local/tables.dart';
import 'package:flutter/material.dart' as m;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_db.g.dart';

@DriftDatabase(
    tables: [ExpenseTable, CategoryTable], daos: [ExpenseDao, CategoryDao])
class ExpensesDatabase extends _$ExpensesDatabase {
  ExpensesDatabase() : super(_openDatabase());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        beforeOpen: (details) async {
          // Ensure categories exist every time the database opens
          final count =
              await customSelect('SELECT COUNT(*) as count FROM category_table')
                  .map((row) => row.read<int>('count'))
                  .getSingle();
          if (count == 0) {
            await batch((batch) {
              batch.insertAll(categoryTable, [
                CategoryTableCompanion.insert(
                    name: "Housing",
                    iconCode: m.Icons.house.codePoint,
                    color: m.Colors.red.value),
                CategoryTableCompanion.insert(
                    name: "Transportation",
                    iconCode: m.Icons.emoji_transportation.codePoint,
                    color: m.Colors.blue.value),
                CategoryTableCompanion.insert(
                    name: "Food",
                    iconCode: m.Icons.restaurant.codePoint,
                    color: m.Colors.green.value),
                CategoryTableCompanion.insert(
                    name: "Utilities",
                    iconCode: m.Icons.category.codePoint,
                    color: m.Colors.yellow.value),
                CategoryTableCompanion.insert(
                    name: "Insurance",
                    iconCode: m.Icons.health_and_safety.codePoint,
                    color: m.Colors.purple.value),
                CategoryTableCompanion.insert(
                    name: "Medical & Healthcare",
                    iconCode: m.Icons.medical_information.codePoint,
                    color: m.Colors.grey.value),
                CategoryTableCompanion.insert(
                    name: "Saving, Investing, & Debt Payment",
                    iconCode: m.Icons.attach_money.codePoint,
                    color: m.Colors.pink.value),
                CategoryTableCompanion.insert(
                    name: "Personal Spending",
                    iconCode: m.Icons.house.codePoint,
                    color: m.Colors.brown.value),
                CategoryTableCompanion.insert(
                    name: "Recreation & Entertainment",
                    iconCode: m.Icons.tv.codePoint,
                    color: m.Colors.orange.value),
                CategoryTableCompanion.insert(
                    name: "Miscellaneous",
                    iconCode: m.Icons.library_books_sharp.codePoint,
                    color: m.Colors.blueGrey.value),
              ]);
            });
          }
        },
      );
}

/// helper function that returns an instance of QueryExecutor
LazyDatabase _openDatabase() {
  return LazyDatabase(() async {
    // Get internal app storage directory
    Directory directory =
        await getApplicationDocumentsDirectory(); // Internal storage
    final dbFolder = Directory(p.join(directory.path, 'ExpenseApp'));

    // Ensure the directory exists
    if (!dbFolder.existsSync()) {
      dbFolder.createSync(recursive: true);
    }

    // Define the database file path
    final file = File(p.join(dbFolder.path, 'dbexpenses.sqlite'));

    // Return the database
    return NativeDatabase(file, logStatements: true);
  });
}

@DriftAccessor(tables: [ExpenseTable])
class ExpenseDao extends DatabaseAccessor<ExpensesDatabase>
    with _$ExpenseDaoMixin {
  final ExpensesDatabase db;
  ExpenseDao(this.db) : super(db);

  /// Select all current expenses present in ExpenseTable
  Future<List<dynamic>> selectAllExpenses() {
    try {
      final list = select(expenseTable).get();
      return list;
    } on SqliteException {
      rethrow;
    }
  }

  /// Insert an expense in ExpenseTable
  Future<void> insertExpense(
      Insertable<ExpenseTableData> expenseToInsert) async {
    var expenseTemp = expenseToInsert as ExpenseTableCompanion;
    try {
      final expenseDataList =
          await select(expenseTable).get(); //Get list of saved tables
      bool verification = expenseDataList.every((expenseTableData) =>
          expenseTemp.description.value !=
          expenseTableData.description); // Insert condition verification
      if (verification) {
        into(expenseTable).insert(expenseToInsert);
      }
    } on SqliteException {
      rethrow;
    }
  }
}

@DriftAccessor(tables: [CategoryTable])
class CategoryDao extends DatabaseAccessor<ExpensesDatabase>
    with _$CategoryDaoMixin {
  final ExpensesDatabase db;
  CategoryDao(this.db) : super(db);

  /// Select all current categories present in CategoryTable
  Future<List<dynamic>> selectAllCategories() {
    try {
      final list = select(categoryTable).get();
      return list;
    } on SqliteException {
      rethrow;
    }
  }

  /// Insert a category in CategoryTable
  Future<void> insertCategory(
      Insertable<CategoryTableData> categoryToInsert) async {
    var catTemp = categoryToInsert as CategoryTableCompanion;
    try {
      final categoryDataList =
          await select(categoryTable).get(); //Get list of saved categories
      bool verification = categoryDataList.every((categoryTableData) =>
          catTemp.name.value !=
          categoryTableData.name); // Insert condition verification
      if (verification) {
        into(categoryTable).insert(categoryToInsert);
      }
    } on SqliteException {
      rethrow;
    }
  }
}
