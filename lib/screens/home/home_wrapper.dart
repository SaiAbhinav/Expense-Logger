import 'package:expense_logger/models/expense.dart';
import 'package:expense_logger/models/user.dart';
import 'package:expense_logger/screens/home/account.dart';
import 'package:expense_logger/screens/home/expense_form.dart';
import 'package:expense_logger/screens/home/home.dart';
import 'package:expense_logger/screens/home/transactions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_logger/services/database.dart';

class HomeWrapper extends StatefulWidget {
  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
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
          return Home(callback: onTabTapped);
          break;
        case 1:
          return Transactions();
          break;
        case 2:
          return Account();
          break;
        default:
          return Home(callback: onTabTapped);
          break;
      }
    }

    return StreamProvider<List<Expense>>.value(
      value: DatabaseService(uid: user.uid).expenses,
      child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
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
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: Colors.black87,
            unselectedItemColor: Colors.black26,
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.description),
                title: new Text('Transactions'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                title: Text('Account'),
              )
            ],
          ),
          body: _getChildren(_currentIndex)),

      // child: Scaffold(
      //   appBar: AppBar(
      //     title: Text('Expense Logger'),
      //     actions: <Widget>[
      //       IconButton(
      //         icon: Icon(Icons.power_settings_new),
      //         color: Colors.white,
      //         onPressed: () async {
      //           print(_authService.isSignInWithGoogle());
      //           await _authService.isSignInWithGoogle() ? _authService.signOutFromGoogle() : _authService.signOut();
      //         },
      //       ),
      //     ],
      //   ),
      //   body: ExpenseList(),
      //   floatingActionButton: FloatingActionButton.extended(
      //     backgroundColor: Colors.blue,
      //     icon: Icon(Icons.add),
      //     label: Text('Expense'),
      //     onPressed: () {
      //       _showExpensePanel();
      //     },
      //   ),
      // ),
    );
  }
}
