import 'package:expense_tracker_cc/core/common/widgets/loader.dart';
import 'package:expense_tracker_cc/features/expenses/domain/entities/category.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/bloc/category/category_bloc.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/widgets/category_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  @override
  void initState() {
    context.read<CategoryBloc>().add(CategoryFetchAll());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:
            BlocBuilder<CategoryBloc, CategoryState>(builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: Loader());
          }
          if (state is CategoryFailure) {
            return Center(
              child: Text(state.error),
            );
          }
          if (state is CategoriesDisplaySuccess) {
            return ListView.separated(
              itemCount: state.categories.length,
              itemBuilder: (builder, index) {
                Category category = state.categories[index];

                return ListTile(
                  onTap: () {},
                  leading: CircleAvatar(
                    backgroundColor: category.color.withOpacity(0.2),
                    child: Icon(
                      category.icon,
                      color: category.color,
                    ),
                  ),
                  title: Text(
                    category.name,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.merge(
                        const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15)),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  width: double.infinity,
                  color: Colors.grey.withAlpha(25),
                  height: 1,
                  margin: const EdgeInsets.only(left: 75, right: 20),
                );
              },
            );
          }
          return Container();
        }),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            await showDialog(
                context: context, builder: (builder) => const CategoryForm());
            context.read<CategoryBloc>().add(CategoryFetchAll());
          },
        ));
  }
}
