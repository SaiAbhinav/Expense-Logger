import 'package:expense_logger/services/auth.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: RaisedButton(
          onPressed: () async {            
            await _authService.isSignInWithGoogle()
                ? _authService.signOutFromGoogle()
                : _authService.signOut();
          },
          child: Text('Logout'),
        ),
      ),
    );
  }
}
