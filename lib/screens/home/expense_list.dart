import 'package:expense_logger/models/expense.dart';
import 'package:expense_logger/screens/home/expense_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseList extends StatefulWidget {
  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<List<Expense>>(context) ?? [];

    return expenses.length > 0
        ? ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              return ExpenseTile(
                expense: expenses[index],
              );
            },
          )
        : Container(
            child: Center(
              child: Text('Add your expense'),
            ),
          );
  }
}
