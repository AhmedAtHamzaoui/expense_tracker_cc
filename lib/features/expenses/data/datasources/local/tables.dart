import 'package:drift/drift.dart';

class ExpenseTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get amount => real()();
  IntColumn get categoryId => integer()();
  DateTimeColumn get date => dateTime()();
  TextColumn get description => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class CategoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get iconCode => integer()();
  IntColumn get color => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
