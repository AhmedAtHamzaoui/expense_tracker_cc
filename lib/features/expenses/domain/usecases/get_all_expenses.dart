import 'package:expense_tracker_cc/core/error/failures.dart';
import 'package:expense_tracker_cc/core/usecase/usecase.dart';
import 'package:expense_tracker_cc/features/expenses/domain/entities/expense.dart';
import 'package:expense_tracker_cc/features/expenses/domain/repositories/expenses_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllExpenses implements UseCase<List<Expense>, NoParams> {
  final ExpensesRepository expensesRepository;
  GetAllExpenses(this.expensesRepository);

  @override
  Future<Either<Failure, List<Expense>>> call(NoParams params) {
    return Future.value(expensesRepository.getExpenses());
  }
}
