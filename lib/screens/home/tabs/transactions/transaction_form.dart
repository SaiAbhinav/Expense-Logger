import 'package:expense_logger/models/expense.dart';
import 'package:expense_logger/models/user.dart';
import 'package:expense_logger/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TransactionForm extends StatefulWidget {
  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _formKey = GlobalKey<FormState>();
  final _transactionTypes = ['IN', 'OUT'];
  final _outPaymentTypes = ['CARD', 'FOOD CARD', 'CASH', 'UPI'];
  final _inPaymentTypes = ['ACCOUNT', 'CASH'];
  final _outCategories = ['FOOD', 'TRANSPORT'];
  final _inCategories = ['SALARY'];

  // form values
  String _date;
  String _paymentType;
  String _transactionType = 'OUT';
  String _category;
  String _description;
  String _amount;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    String _padZero(int val) {
      if (val < 9) {
        return '0$val';
      } else {
        return '$val';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add a Transaction'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text(
                'Log your expense.',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              FlatButton(
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 250.0,
                        itemHeight: 50.0,
                      ),
                      showTitleActions: true,
                      minTime: DateTime(2000, 1, 1),
                      maxTime: DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day), onConfirm: (date) {
                    setState(() => _date =
                        '${_padZero(date.day)}_${_padZero(date.month)}_${date.year}');
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child: Text(_date ?? 'Date'),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
                color: Colors.white,
              ),
              // TextFormField(
              //   decoration: InputDecoration(hintText: 'Date'),
              //   validator: (val) => val.isEmpty ? 'Please enter date' : null,
              //   onChanged: (val) => setState(() => _date = val),
              // ),
              DropdownButtonFormField(
                value: _transactionType,
                decoration: InputDecoration(hintText: 'Transaction Type'),
                items: _transactionTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _transactionType = val),
              ),
              DropdownButtonFormField(
                value: _paymentType,
                decoration: InputDecoration(hintText: 'Payment Type'),
                items: _transactionType == 'OUT'
                    ? _outPaymentTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList()
                    : _inPaymentTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                onChanged: (val) => setState(() => _paymentType = val),
              ),
              DropdownButtonFormField(
                value: _category,
                decoration: InputDecoration(hintText: 'Category'),
                items: _transactionType == 'OUT'
                    ? _outCategories.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList()
                    : _inCategories.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                onChanged: (val) => setState(() => _category = val),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration: InputDecoration(hintText: 'Description'),
                validator: (val) =>
                    val.isEmpty ? 'Please enter description' : null,
                onChanged: (val) => setState(() => _description = val),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Amount'),
                validator: (val) => val.isEmpty ? 'Please enter amount' : null,
                onChanged: (val) => setState(() => _amount = val),
              ),
              SizedBox(
                height: 20.0,
              ),
              RaisedButton(
                color: Colors.blue,
                child: Text(
                  'Log',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  DatabaseService(uid: user.uid).insertTransactionData(Expense(
                      date: _date,
                      transactionType: _transactionType,
                      paymentType: _paymentType,
                      category: _category,
                      description: _description,
                      amount: _amount));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
