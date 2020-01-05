import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_logger/screens/home/tabs/transactions/transaction_form.dart';
import 'package:expense_logger/screens/home/tabs/transactions/transaction_tile.dart';
import 'package:expense_logger/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;

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

  bool _pickedRange = false;
  List<DateTime> _pickedDatesRange = [];

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

    List<Widget> _getChildren(List<String> keys) {
      return keys.map<Widget>((key) {
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

    List<Widget> _getChildrenInRange() {
      List<String> sortedKeys =
          List<String>.from(transactions.data['transactions'].keys);
      sortedKeys.sort();
      List<String> stringPickedDates = [];
      _pickedDatesRange.forEach((date) {
        stringPickedDates.add(date.toString());
      });
      List<String> pickedRangeDates = [];
      stringPickedDates.forEach((date) {
        String dateString = date.split(' ')[0];
        List<String> splitedDate = dateString.split('-');
        pickedRangeDates
            .add('${splitedDate[2]}_${splitedDate[1]}_${splitedDate[0]}');
      });
      int startIndex = sortedKeys.indexOf(pickedRangeDates[0]) != -1
          ? sortedKeys.indexOf(pickedRangeDates[0])
          : 0;
      int endIndex = sortedKeys.indexOf(pickedRangeDates[1]) != -1
          ? (sortedKeys.indexOf(pickedRangeDates[1]) + 1)
          : sortedKeys.length;
      print(sortedKeys.sublist(startIndex, endIndex));
      List<String> subList = sortedKeys.sublist(startIndex, endIndex);
      subList.sort((b, a) => a.compareTo(b));
      return _getChildren(subList);
    }

    List<Widget> _getAllChildren() {
      List<String> sortedKeys =
          List<String>.from(transactions.data['transactions'].keys);
      sortedKeys.sort((b, a) => a.compareTo(b));
      return _getChildren(sortedKeys);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          _pickedRange
              ? Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FlatButton.icon(
                    splashColor: Colors.transparent,
                    label: Text(
                      'Clear range',
                      style: TextStyle(color: Colors.black38),
                    ),
                    color: Colors.white,
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        _pickedRange = false;
                      });
                    },
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FlatButton.icon(
                    splashColor: Colors.transparent,
                    label: Text(
                      'Select range',
                      style: TextStyle(color: Colors.black38),
                    ),
                    icon: Icon(
                      Icons.date_range,
                      color: Colors.black38,
                      size: 30.0,
                    ),
                    onPressed: () async {
                      final List<DateTime> picked =
                          await DateRagePicker.showDatePicker(
                        context: context,
                        initialFirstDate: DateTime.now(),
                        initialLastDate: DateTime.now(),
                        firstDate: DateTime(2019, 1, 1),
                        lastDate: DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day + 1),
                      );
                      if (picked != null && picked.length > 1) {
                        setState(() {
                          _pickedRange = true;
                          _pickedDatesRange = picked;
                        });
                      }
                    },
                  ),
                ),
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
                  child: ListView(
                      children: _pickedRange
                          ? _getChildrenInRange()
                          : _getAllChildren()),
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
