class Expense {
  final int? id;
  final double amount;
  final int categoryId;
  final DateTime date;
  final String description;

  Expense(
      {this.id,
      required this.amount,
      required this.categoryId,
      required this.date,
      required this.description});
}
