import 'package:expense_logger/models/expense.dart';
import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {

  final Expense expense;
  ExpenseTile({this.expense});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(expense.category.toString()),
      subtitle: Text(expense.description),
      leading: Text(expense.amount.toString()),
    );
  }
}