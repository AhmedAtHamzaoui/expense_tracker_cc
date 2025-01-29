import 'package:expense_tracker_cc/core/common/widgets/button.dart';
import 'package:expense_tracker_cc/core/common/widgets/icons.dart';
import 'package:expense_tracker_cc/features/expenses/domain/entities/category.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/bloc/category/category_bloc.dart';
import 'package:expense_tracker_cc/features/expenses/presentation/bloc/category_form_bloc/category_form_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef Callback = void Function();

class CategoryForm extends StatefulWidget {
  const CategoryForm({super.key});

  @override
  State<StatefulWidget> createState() => _CategoryForm();
}

class _CategoryForm extends State<CategoryForm> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryFormBloc, CategoryFormState>(
        builder: (context, state) {
      return AlertDialog(
        scrollable: true,
        insetPadding: const EdgeInsets.all(10),
        title: Text(
          "New Category",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: state.color,
                        borderRadius: BorderRadius.circular(40)),
                    alignment: Alignment.center,
                    child: Icon(
                      state.icon,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: TextFormField(
                    decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter Category name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 15)),
                    onChanged: (String text) =>
                        context.read<CategoryFormBloc>().add(NameChanged(text)),
                  ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              //Color picker
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: Colors.primaries.length,
                    itemBuilder: (BuildContext context, index) => Container(
                          width: 45,
                          height: 45,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 2.5, vertical: 2.5),
                          child: GestureDetector(
                              onTap: () => context
                                  .read<CategoryFormBloc>()
                                  .add(ColorSelected(Colors.primaries[index])),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.primaries[index],
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                      width: 2,
                                      color: state.color?.value ==
                                              Colors.primaries[index].value
                                          ? Colors.white
                                          : Colors.transparent,
                                    )),
                              )),
                        )),
              ),
              const SizedBox(
                height: 15,
              ),

              //Icon picker
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: AppIcons.icons.length,
                    itemBuilder: (BuildContext context, index) => Container(
                        width: 45,
                        height: 45,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2.5, vertical: 2.5),
                        child: GestureDetector(
                            onTap: () {
                              context
                                  .read<CategoryFormBloc>()
                                  .add(IconSelected(AppIcons.icons[index]));
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(40),
                                  border: Border.all(
                                      color: state.icon == AppIcons.icons[index]
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Colors.transparent,
                                      width: 2)),
                              child: Icon(
                                AppIcons.icons[index],
                                color: Theme.of(context).colorScheme.primary,
                                size: 18,
                              ),
                            )))),
              ),
            ],
          ),
        ),
        actions: [
          AppButton(
            height: 45,
            isFullWidth: true,
            onPressed: () {
              if (state.color != null &&
                  state.icon != null &&
                  state.name.isNotEmpty) {
                context.read<CategoryBloc>().add(CategoryUploadEvent(
                    category: Category(
                        name: state.name,
                        icon: state.icon!,
                        color: state.color!)));
                context.read<CategoryFormBloc>().add(SubmitCategoryForm());
              }
            },
            color: Colors.teal,
            label: "Save",
          )
        ],
      );
    });
  }
}
