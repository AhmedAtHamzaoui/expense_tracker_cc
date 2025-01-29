import 'package:expense_tracker_cc/features/expenses/domain/entities/expense.dart';

class ExpenseModel extends Expense {
  ExpenseModel(
      {required super.id,
      required super.amount,
      required super.categoryId,
      required super.date,
      required super.description});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'category': categoryId,
      'date': date,
      'description': description
    };
  }

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'],
      amount: json['amount'],
      categoryId: json['category'],
      date: json['date'],
      description: json['description'],
    );
  }

  ExpenseModel copyWith({
    int? id,
    double? amount,
    int? categoryId,
    DateTime? date,
    String? description,
  }) {
    return ExpenseModel(
        id: id ?? this.id,
        amount: amount ?? this.amount,
        categoryId: categoryId ?? this.categoryId,
        date: date ?? this.date,
        description: description ?? this.description);
  }
}
