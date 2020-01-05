import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  final Function callback;
  Dashboard({this.callback});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
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
                // trailing: GestureDetector(
                //   onTap: () {
                //     callback(1);
                //   },
                //   child: Text(
                //     'View All',
                //     style: TextStyle(
                //       color: Colors.blue,
                //       fontSize: 13.0,
                //     ),
                //   ),
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
