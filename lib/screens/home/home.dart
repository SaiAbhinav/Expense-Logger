import 'package:expense_logger/models/expense.dart';
import 'package:expense_logger/models/user.dart';
import 'package:expense_logger/screens/home/dashboard.dart';
import 'package:expense_logger/screens/home/expense_form.dart';
import 'package:expense_logger/screens/home/settings.dart';
import 'package:expense_logger/screens/home/transactions.dart';
import 'package:expense_logger/shared/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_logger/services/database.dart';

class Home extends StatefulWidget {
  final List<NavBarItem> navBarItems = [
    NavBarItem(icon: Icons.dashboard, label: 'Dashboard'),
    NavBarItem(icon: Icons.description, label: 'Transactions'),
    NavBarItem(icon: Icons.settings, label: 'Settings')
  ];

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

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

    Widget _getChildren(int index) {
      switch (index) {
        case 0:
          return Dashboard(callback: onTabTapped);
          break;
        case 1:
          return Transactions();
          break;
        case 2:
          return Settings();
          break;
        default:
          return Dashboard(callback: onTabTapped);
          break;
      }
    }

    return StreamProvider<List<Expense>>.value(
      value: DatabaseService(uid: user.uid).expenses,
      child: Scaffold(
          floatingActionButton: _currentIndex == 1
              ? FloatingActionButton.extended(
                  backgroundColor: Colors.white,
                  icon: Icon(
                    Icons.add,
                    color: Colors.grey,
                  ),
                  label: Text(
                    'Expense',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                  ),
                  onPressed: () {
                    _showExpensePanel();
                  },
                )
              : Container(),
          bottomNavigationBar: BottomNavBar(
              navBarItems: widget.navBarItems,
              animationDuration: new Duration(milliseconds: 200),
              onNavBarTap: (index) {
                onTabTapped(index);
              }),
          body: _getChildren(_currentIndex)),
      // bottomNavigationBar: BottomNavigationBar(
      //   selectedItemColor: Colors.black87,
      //   unselectedItemColor: Colors.black26,
      //   currentIndex: _currentIndex,
      //   onTap: onTabTapped,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.dashboard),
      //       title: Text('Dashboard'),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.description),
      //       title: new Text('Transactions'),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.settings),
      //       title: Text('Settings'),
      //     )
      //   ],
      // ),
    );
  }
}
