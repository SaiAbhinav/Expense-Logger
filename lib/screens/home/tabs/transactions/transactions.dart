import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_logger/screens/home/tabs/transactions/transaction_form.dart';
import 'package:expense_logger/screens/home/tabs/transactions/transaction_tile.dart';
import 'package:expense_logger/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  String _formatDate(String date) {
    var dateArr = date.split('_');
    var dateTimeObj = DateTime(
        int.parse(dateArr[2]), int.parse(dateArr[1]), int.parse(dateArr[0]));
    var formatter = new DateFormat('EEE, MMM dd, yyyy');
    return formatter.format(dateTimeObj);
  }

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<DocumentSnapshot>(context);

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

    String _getDailySpentAmount(String key) {
      int total = 0;
      List<dynamic> dailyTransactions = transactions.data['transactions'][key];
      dailyTransactions.forEach((dailyTransaction) {
        if (dailyTransaction['transactionType'] == 'OUT') {
          total += int.parse(dailyTransaction['amount']);
        }
      });
      return total.toString();
    }

    List<Widget> _getChildren() {
      List<String> sortedKeys = List<String>.from(transactions.data['transactions'].keys);
      sortedKeys.sort((b, a) => a.compareTo(b));      
      return sortedKeys.map<Widget>((key) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                right: 18.0,
                left: 18.0,
                top: 14.0,
                bottom: 6.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _formatDate(key),
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '- ₹ ${_getDailySpentAmount(key)}',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            TransactionTile(
                keyName: key, keyValue: transactions.data['transactions'][key])
          ],
        );
      }).toList();
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(
                Icons.date_range,
                color: Colors.black38,
                size: 30.0,
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
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
      body: transactions != null
          ? transactions.data['transactions'] != null
              ? Container(
                  color: Colors.grey[200],
                  width: double.infinity,
                  height: double.infinity,
                  // padding: EdgeInsets.only(top: 20.0),
                  child: ListView(children: _getChildren()),
                )
              : Container(
                  child: Center(
                    child: Text('Add a transaction'),
                  ),
                )
          : Loading(),
    );
  }
}
