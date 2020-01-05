import 'package:expense_logger/services/auth.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
