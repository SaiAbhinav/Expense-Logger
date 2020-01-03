import 'package:expense_logger/models/expense.dart';
import 'package:expense_logger/models/user.dart';
import 'package:expense_logger/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class ExpenseForm extends StatefulWidget {
  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final _paymentTypes = ['CARD', 'FOOD CARD', 'CASH', 'UPI'];
  final _categories = ['FOOD', 'TRANSPORT'];

  // form values
  String _date;
  String _paymentType;
  String _category;
  String _description;
  String _amount;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    String _addZeroPadding(int val) {
      if (val < 9) {
        return '0$val';
      } else {
        return '$val';
      }
    }

    return SingleChildScrollView(
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
                    maxTime: DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day), onConfirm: (date) {
                  setState(() => _date =
                      '${_addZeroPadding(date.day)} - ${_addZeroPadding(date.month)} - ${date.year}');
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
              value: _paymentType,
              decoration: InputDecoration(hintText: 'Payment Type'),
              items: _paymentTypes.map((type) {
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
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
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
                DatabaseService(uid: user.uid).insertExpenseData(Expense(
                    date: _date,
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
    );
  }
}
