import 'package:expense_tracker_cc/features/expenses/presentation/bloc/category/category_bloc.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/bloc/category_form_bloc/category_form_bloc.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/bloc/expense/expense_bloc.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/bloc/expense_form/expense_form_bloc.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/bloc/navigation/navigation_bloc.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/screens/categories_tab.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/screens/charts_tab.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/screens/expenses_tab.dart';
import 'package:expense_tracker_cc/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependecies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => serviceLocator<NavigationBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<ExpenseBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<CategoryBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<ExpenseFormBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<CategoryFormBloc>(),
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense tracker cc',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'HomePage'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  final List<Widget> tabs = [
    ExpensesTab(),
    CategoriesTab(),
    ChartsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Expense tracking app'),
          centerTitle: true,
        ),
        body: tabs[state.selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          currentIndex: state.selectedIndex,
          onTap: (value) =>
              context.read<NavigationBloc>().add(TabChanged(value)),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: 'Categories'),
            BottomNavigationBarItem(
                icon: Icon(Icons.pie_chart), label: 'Charts')
          ],
        ),
      );
    });
  }
}
