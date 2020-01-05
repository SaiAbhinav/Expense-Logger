import 'package:expense_logger/models/expense.dart';
import 'package:expense_logger/screens/home/tabs/transactions/transaction.dart';
import 'package:expense_logger/screens/home/tabs/transactions/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<List<Expense>>(context) ?? [];

    void _showExpensePanel() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: TransactionForm(),
          );
        },
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        icon: Icon(
          Icons.add,
          color: Colors.grey,
        ),
        label: Text(
          'Transaction',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 16.0,
          ),
        ),
        onPressed: () {
          _showExpensePanel();
        },
      ),
      body: expenses.length > 0
          ? ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                return Transaction(
                  expense: expenses[index],
                );
              },
            )
          : Container(
              child: Center(
                child: Text('Add your expense'),
              ),
            ),
    );
  }
}
