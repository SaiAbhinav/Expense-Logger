import 'package:expense_logger/services/auth.dart';
import 'package:expense_logger/shared/constants.dart';
import 'package:expense_logger/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  bool _rememberMe = false;

  // text field state
  String email = '';
  String password = '';
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
                          Color(0xFF73AEF5),
                          Color(0xFF61A4F1),
                          Color(0xFF478DE0),
                          Color(0xFF398AE5)
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
                                'Sign In',
                                style: TextStyle(
                                    color: Colors.white,
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
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(top: 14.0),
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Colors.white,
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
                                        color: Colors.white,
                                        fontSize: 18.0,
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(top: 14.0),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                        ),
                                        hintText: 'Enter your Password',
                                        hintStyle: kHintTextStyle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: FlatButton(
                                  padding: EdgeInsets.only(right: 0.0),
                                  onPressed: () async {
                                    dynamic result = await _authService
                                        .resetPassword(context, email);
                                    if (result is String || result == null) {
                                      setState(() {
                                        error = result ?? '';
                                      });
                                    }
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: kLabelStyle,
                                  ),
                                ),
                              ),
                              // Container(
                              //   child: Row(
                              //     children: <Widget>[
                              //       Theme(
                              //         data: ThemeData(
                              //             unselectedWidgetColor: Colors.white),
                              //         child: Checkbox(
                              //           value: _rememberMe,
                              //           checkColor: Colors.blue,
                              //           activeColor: Colors.white,
                              //           onChanged: (val) =>
                              //               setState(() => _rememberMe = val),
                              //         ),
                              //       ),
                              //       Text(
                              //         'Remember me',
                              //         style: kLabelStyle,
                              //       )
                              //     ],
                              //   ),
                              // ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 25.0),
                                width: double.infinity,
                                child: RaisedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      if (email != '' &&
                                          password != '' &&
                                          password.length >= 8) {
                                        setState(() => loading = true);
                                        dynamic result = await _authService
                                            .signInWithEmailAndPassword(
                                                email, password);
                                        if (result is String ||
                                            result == null) {
                                          setState(() {
                                            error = result ?? '';
                                            loading = false;
                                          });
                                        }
                                      } else {
                                        if (email == '') {
                                          setState(
                                              () => error = 'Enter an email');
                                        } else if (password == '') {
                                          setState(
                                              () => error = 'Enter a password');
                                        } else if (password.length < 8) {
                                          setState(() => error =
                                              'Password should be 8+ chars long');
                                        }
                                      }
                                    }
                                  },
                                  elevation: 5.0,
                                  padding: EdgeInsets.all(15.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  color: Colors.white,
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      color: Color(0xFF527DAA),
                                      letterSpacing: 1.5,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                    ),
                                  ),
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    '- OR -',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  Text(
                                    'Sign in with',
                                    style: kLabelStyle,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 60.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        // GestureDetector(
                                        //   onTap: () {
                                        //     print(
                                        //         'Pressed Sign in with facebook');
                                        //   },
                                        //   child: Container(
                                        //     height: 60.0,
                                        //     width: 60.0,
                                        //     decoration: BoxDecoration(
                                        //       shape: BoxShape.circle,
                                        //       color: Colors.white,
                                        //       boxShadow: [
                                        //         BoxShadow(
                                        //           color: Colors.black26,
                                        //           offset: Offset(0, 2),
                                        //           blurRadius: 6.0,
                                        //         ),
                                        //       ],
                                        //       image: DecorationImage(
                                        //         image: AssetImage(
                                        //             'assets/logos/facebook.jpg'),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // ),
                                        GestureDetector(
                                          onTap: () async {
                                            print(
                                                'Pressed Sign in with Google');
                                            setState(() => loading = true);
                                            dynamic result = await _authService
                                                .signInWithGoogle();
                                            if (result is String ||
                                                result == null) {
                                              setState(() {
                                                error = result ?? '';
                                                loading = false;
                                              });
                                            }
                                          },
                                          child: Container(
                                            height: 60.0,
                                            width: 60.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  offset: Offset(0, 2),
                                                  blurRadius: 6.0,
                                                ),
                                              ],
                                              image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/logos/google.jpg'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
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
                                    height: 85.0,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      widget.toggleView();
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Don\'t have an Account ? ',
                                            style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Sign Up',
                                            style: TextStyle(
                                              color: Colors.white,
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
