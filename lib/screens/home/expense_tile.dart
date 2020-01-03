import 'package:expense_logger/models/expense.dart';
import 'package:expense_logger/models/user.dart';
import 'package:expense_logger/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  ExpenseTile({this.expense});

  IconData _getPaymentIcon(String paymentType) {
    switch (paymentType) {
      case 'CARD':
      case 'FOOD CARD':
        return Icons.payment;
        break;
      case 'CASH':
        return Icons.monetization_on;
        break;
      case 'UPI':
        return Icons.phone_android;
        break;
      default:
        return Icons.payment;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    void _showExpenseDetails() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: Column(
                children: <Widget>[
                  Text(expense.uid),
                  Text(expense.date),
                  Text(expense.category),
                  Text(expense.paymentType),
                  Text(expense.description),
                  Text(expense.amount),
                  FlatButton.icon(
                    icon: Icon(Icons.delete),
                    label: Text('Delete'),
                    onPressed: () {
                      DatabaseService(uid: user.uid).deleteExpenseData(expense.uid);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          });
    }

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
        child: ListTile(
          leading: Icon(
            _getPaymentIcon(expense.paymentType),
            size: 35.0,
            color: Colors.blue,
          ),
          title: Text(expense.amount),
          subtitle: Text(expense.description),
          onTap: () {
            _showExpenseDetails();
          },
        ),
      ),
    );
  }
}
