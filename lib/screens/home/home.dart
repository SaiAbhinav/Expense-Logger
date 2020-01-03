import 'package:expense_logger/models/expense.dart';
import 'package:expense_logger/screens/home/expense_form.dart';
import 'package:expense_logger/screens/home/expense_list.dart';
import 'package:expense_logger/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_logger/services/database.dart';

class Home extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    void _showExpensePanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: ExpenseForm(),
            );
          });
    }    

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Logger'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new),
            color: Colors.white,
            onPressed: () async {
              await _authService.signOut();
            },
          ),
        ],
      ),
      body: ExpenseList(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        icon: Icon(Icons.add),
        label: Text('Expense'),
        onPressed: () {
          _showExpensePanel();
        },
      ),
    );
  }
}
