import 'package:expense_logger/models/user.dart';
import 'package:expense_logger/screens/authentication/authentication.dart';
import 'package:expense_logger/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

 @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);    

    // return either authentication or home widgets
    return user == null ? Authentication() : Home();
  }
}