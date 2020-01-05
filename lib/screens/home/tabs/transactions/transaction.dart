import 'package:expense_logger/models/expense.dart';
import 'package:expense_logger/models/user.dart';
import 'package:expense_logger/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Transaction extends StatelessWidget {
  final Expense expense;
  Transaction({this.expense});

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

    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Dismissible(
        key: Key(expense.toString()),      
        direction: DismissDirection.endToStart,  
        background: Container(
          padding: EdgeInsets.only(right: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ],
          ),
          color: Colors.red,
        ),
        onDismissed: (direction) {
          DatabaseService(uid: user.uid).deleteExpenseData(expense.uid);
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Expense has been deleted...!!!'),
            ),
          );
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 6.0),
          child: ExpansionTile(
            leading: Icon(
              _getPaymentIcon(expense.paymentType),
              size: 35.0,
              color: Colors.blue,
            ),
            title: Text(expense.category),
            subtitle: Text(expense.date),
            trailing: Text(expense.amount),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 72.0),
                    child: Text(expense.description),
                  ),
                ],
              )
            ],
            // onTap: () {
            //   _showExpenseDetails();
            // },
          ),
        ),
      ),
    );
  }
}
