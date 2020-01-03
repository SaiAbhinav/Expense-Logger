import 'package:flutter/material.dart';

class ExpenseList extends StatefulWidget {
  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  @override
  Widget build(BuildContext context) {    

    return Container(
      child: Center(
        child: Text('Add your expense'),
      ),
    );
  }
}
