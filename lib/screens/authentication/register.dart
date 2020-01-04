import 'package:expense_logger/services/auth.dart';
import 'package:expense_logger/shared/constants.dart';
import 'package:expense_logger/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String confirmPassword = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFFFFFFF),
                          Color(0xFFEEEEEE),
                          Color(0xFFDDDDDD),
                          Color(0xFFCCCCCC)
                        ],
                        stops: [0.1, 0.4, 0.7, 0.9],
                      )),
                    ),
                    Container(
                      height: double.infinity,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.only(
                          top: 120.0,
                          right: 40.0,
                          left: 40.0,
                          bottom: 40.0,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontFamily: 'OpenSans',
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Email',
                                    style: kLabelStyle,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: kBoxDecorationStyle,
                                    height: 60.0,
                                    child: TextFormField(
                                      validator: (val) =>
                                          val.isEmpty ? null : null,
                                      onChanged: (val) =>
                                          setState(() => email = val),
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 18.0,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(top: 14.0),
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Colors.black26,
                                        ),
                                        hintText: 'Enter your Email',
                                        hintStyle: kHintTextStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Password',
                                    style: kLabelStyle,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: kBoxDecorationStyle,
                                    height: 60.0,
                                    child: TextFormField(
                                      validator: (val) =>
                                          val.length < 8 ? null : null,
                                      onChanged: (val) =>
                                          setState(() => password = val),
                                      obscureText: true,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 18.0,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(top: 14.0),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Colors.black26,
                                        ),
                                        hintText: 'Enter your Password',
                                        hintStyle: kHintTextStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Confirm Password',
                                    style: kLabelStyle,
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    decoration: kBoxDecorationStyle,
                                    height: 60.0,
                                    child: TextFormField(
                                      validator: (val) =>
                                          val.length < 8 && val == password
                                              ? null
                                              : null,
                                      onChanged: (val) =>
                                          setState(() => confirmPassword = val),
                                      obscureText: true,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 18.0,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(top: 14.0),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Colors.black26,
                                        ),
                                        hintText: 'Confirm Password',
                                        hintStyle: kHintTextStyle,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 25.0),
                                    width: double.infinity,
                                    child: RaisedButton(
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          if (email != '' &&
                                              password != '' &&
                                              password.length >= 8 &&
                                              confirmPassword != '' &&
                                              password == confirmPassword) {
                                            setState(() => loading = true);
                                            dynamic result = await _authService
                                                .registerUserWithEmailAndPassword(
                                                    email, password);
                                            if (result is String || result == null) {
                                              setState(() {
                                                error = result ?? '';
                                                loading = false;
                                              });
                                            }
                                          } else {
                                            if (email == '') {
                                              setState(() =>
                                                  error = 'Enter an email');
                                            } else if (password == '') {
                                              setState(() =>
                                                  error = 'Enter a password');
                                            } else if (password.length < 8) {
                                              setState(() => error =
                                                  'Password should be 8+ chars long');
                                            } else if (confirmPassword == '') {
                                              setState(() => error =
                                                  'Enter confirm password');
                                            } else if (password !=
                                                confirmPassword) {
                                              setState(() => error =
                                                  'Passwords did not match');
                                            }
                                          }
                                        }
                                      },
                                      elevation: 5.0,
                                      padding: EdgeInsets.all(15.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      color: Colors.white,
                                      child: Text(
                                        'REGISTER',
                                        style: TextStyle(
                                          color: Color(0xFF666666),
                                          letterSpacing: 1.5,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'OpenSans',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text(
                                error,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(
                                height: 150.0,
                              ),
                              Column(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      widget.toggleView();
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Have an Account ? ',
                                            style: TextStyle(
                                              color: Colors.black38,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Sign In',
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
