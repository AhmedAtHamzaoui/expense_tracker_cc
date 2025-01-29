import 'package:expense_tracker_cc/core/common/widgets/loader.dart';
import 'package:expense_tracker_cc/features/expenses/domain/entities/category.dart';
import 'package:expense_tracker_cc/features/expenses/domain/entities/expense.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/bloc/category/category_bloc.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/bloc/expense/expense_bloc.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/widgets/expense_form.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ExpensesTab extends StatefulWidget {
  const ExpensesTab({super.key});

  @override
  State<ExpensesTab> createState() => _ExpensesTabState();
}

class _ExpensesTabState extends State<ExpensesTab> {
  @override
  void initState() {
    context.read<ExpenseBloc>().add(ExpenseFetchAll());
    context.read<CategoryBloc>().add(CategoryFetchAll());
    super.initState();
  }

  Map<Category, double> getCategoryExpenses(
      List<Expense> expenses, List<Category> categories) {
    Map<int, double> categoryExpenseMap = {};

    for (var expense in expenses) {
      categoryExpenseMap.update(
          expense.categoryId, (value) => value + expense.amount,
          ifAbsent: () => expense.amount);
    }

    return categories
        .where((cat) => categoryExpenseMap.containsKey(cat.id))
        .fold({}, (map, cat) {
      map[cat] = categoryExpenseMap[cat.id]!;
      return map;
    });
  }

  List<PieChartSectionData> getPieChartSections(
      Map<Category, double> categoryExpenses) {
    double total = categoryExpenses.values.fold(0, (sum, value) => sum + value);

    return categoryExpenses.entries.map((entry) {
      double percentage = (entry.value / total) * 100;
      return PieChartSectionData(
          value: entry.value,
          color: entry.key.color,
          title: '${percentage.toStringAsFixed(1)}%',
          showTitle: false,
          radius: 25);
    }).toList();
  }

  List<Widget> buildLegend(Map<Category, double> categoryExpenses) {
    return categoryExpenses.keys.map((category) {
      return Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: category.color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              category.name,
              style: TextStyle(fontSize: 16),
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
              if (state is ExpensesDisplaySuccess) {
                final categoryExpenses =
                    getCategoryExpenses(state.expenses, state.categories);
                final sections = getPieChartSections(categoryExpenses);
                final legendItems = buildLegend(categoryExpenses);
                double totalExpenses = categoryExpenses.values
                    .fold(0, (sum, value) => sum + value);
                if (state.expenses.isEmpty) {
                  return Center(child: Text('No expenses yet'));
                }
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: PieChart(
                                  PieChartData(
                                      sections: sections,
                                      centerSpaceRadius: 30,
                                      sectionsSpace: 4),
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Flexible(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: legendItems),
                            )
                          ],
                        ),
                        // Total Expenses Display
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Total Expenses: €${totalExpenses.toStringAsFixed(2)}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
              return Center(child: Loader());
            }),
          ),
          Expanded(
            child: BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
              if (state is ExpenseLoading) {
                return Center(child: Loader());
              }
              if (state is ExpenseFailure) {
                return Center(child: Text(state.error));
              }
              if (state is ExpensesDisplaySuccess) {
                return ListView.builder(
                  itemCount: state.expenses.length,
                  itemBuilder: (context, index) {
                    final transaction = state.expenses[index];
                    final category = state.categories.firstWhere(
                      (cat) => cat.id == transaction.categoryId,
                    );
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: category.color,
                        child: Icon(category.icon, color: Colors.white),
                      ),
                      title: Text(transaction.description,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          "${DateFormat("dd/MM/yyyy").format(transaction.date)} "),
                      trailing: Text("€${transaction.amount}",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    );
                  },
                );
              }
              return Container();
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => ExpenseForm(),
          );
          context.read<ExpenseBloc>().add(ExpenseFetchAll());
        },
      ),
    );
  }
}
