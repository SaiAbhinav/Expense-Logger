import 'package:expense_logger/services/auth.dart';
import 'package:expense_logger/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text('Sign in to Expense Logger'),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.person_add),
                  label: Text('Register'),
                  onPressed: () {
                    widget.toggleView();
                  },
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Email'),
                      validator: (val) => val.isEmpty ? 'Enter an email' : null,
                      onChanged: (val) => setState(() => email = val),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(hintText: 'Password'),
                      validator: (val) => val.length < 8
                          ? 'Enter a password 8+ chars long'
                          : null,
                      onChanged: (val) => setState(() => password = val),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RaisedButton(
                      color: Colors.blue,
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _authService
                              .signInWithEmailAndPassword(email, password);
                          if (result is String) {
                            setState(() {
                              error = result;
                              loading = false;
                            });
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      error,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
