import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(top: 40.0, right: 24.0, left: 24.0),
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 30.0,
            ),
            Text(
              'Hi User',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 30.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.grey[200],
              ),
              child: ListTile(
                title: Text(
                  '₹ 13,200',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Total Expense Till Now',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
