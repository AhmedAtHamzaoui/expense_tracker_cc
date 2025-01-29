import 'package:expense_tracker_cc/core/common/widgets/button.dart';
import 'package:expense_tracker_cc/core/common/widgets/loader.dart';
import 'package:expense_tracker_cc/features/expenses/domain/entities/category.dart';
import 'package:expense_tracker_cc/features/expenses/domain/entities/expense.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/bloc/category/category_bloc.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/bloc/expense/expense_bloc.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/bloc/expense_form/expense_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExpenseFormBloc, ExpenseFormState>(
      builder: (context, expenseState) {
        return Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                    child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 25,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 25),
                    child: Text(
                      'New Expense',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 25),
                    child: _buildDescriptionField(context),
                  ),
                  Container(
                      margin: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 25),
                      child: _buildAmountField(context)),
                  Container(
                      margin: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 25),
                      child: _buildDatePickerField(context, expenseState)),
                  Container(
                    padding: const EdgeInsets.only(left: 15, bottom: 15),
                    child: const Text(
                      "Select Category",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                  BlocBuilder<CategoryBloc, CategoryState>(
                    bloc: context.read<CategoryBloc>(),
                    builder: (context, state) {
                      if (state is CategoryLoading) {
                        return const Center(
                          child: Loader(),
                        );
                      }
                      if (state is CategoriesDisplaySuccess) {
                        return Container(
                          margin: const EdgeInsets.only(
                              bottom: 25, left: 15, right: 15),
                          width: double.infinity,
                          child: Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: List.generate(state.categories.length,
                                  (index) {
                                Category category = state.categories[index];
                                return ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minWidth: 0,
                                    ),
                                    child: IntrinsicWidth(
                                        child: MaterialButton(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withOpacity(0.1),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                side: BorderSide(
                                                    width: 1.5,
                                                    color: expenseState
                                                                .selectedCategory
                                                                ?.id ==
                                                            category.id
                                                        ? Theme.of(context)
                                                            .colorScheme
                                                            .primary
                                                        : Colors.transparent)),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 0),
                                            elevation: 0,
                                            focusElevation: 0,
                                            hoverElevation: 0,
                                            highlightElevation: 0,
                                            disabledElevation: 0,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            onPressed: () {
                                              context
                                                  .read<ExpenseFormBloc>()
                                                  .add(CategorySelected(
                                                      category));
                                            },
                                            onLongPress: () {},
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Row(
                                                children: [
                                                  Icon(category.icon,
                                                      color: category.color),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    category.name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ))));
                              })),
                        );
                      }
                      return Container();
                    },
                  )
                ],
              ),
            ))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: AppButton(
                label: "Add expense",
                height: 50,
                labelStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                isFullWidth: true,
                onPressed: () {
                  if (expenseState.amount != null &&
                      expenseState.amount! > 0 &&
                      expenseState.selectedCategory != null &&
                      expenseState.description.isNotEmpty &&
                      expenseState.selectedDate != null) {
                    context.read<ExpenseBloc>().add(ExpenseUploadEvent(
                        expense: Expense(
                            amount: expenseState.amount!,
                            categoryId: expenseState.selectedCategory!.id!,
                            date: expenseState.selectedDate!,
                            description: expenseState.description)));
                    context.read<ExpenseFormBloc>().add(SubmitExpenseForm());
                  }
                },
                color: Colors.teal,
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    return TextFormField(
      maxLines: null,
      decoration: InputDecoration(
          filled: true,
          hintText: "Description",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 15)),
      onChanged: (value) =>
          context.read<ExpenseFormBloc>().add(DescriptionChanged(value)),
    );
  }

  Widget _buildAmountField(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}')),
      ],
      decoration: InputDecoration(
          filled: true,
          hintText: "Amount",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 15)),
      onChanged: (value) => context
          .read<ExpenseFormBloc>()
          .add(AmountChanged(double.parse(value))),
    );
  }

  Widget _buildDatePickerField(BuildContext context, ExpenseFormState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: InkWell(
                onTap: () async {
                  final picked = await showDatePicker(
                      context: context,
                      initialDate: state.selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now());
                  if (picked != null) {
                    context.read<ExpenseFormBloc>().add(DateSelected(picked));
                  }
                },
                child: Wrap(
                  spacing: 10,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text(state.selectedDate != null
                        ? DateFormat("dd/MM/yyyy").format(state.selectedDate!)
                        : "Select Date")
                  ],
                ))),
      ],
    );
  }
}
