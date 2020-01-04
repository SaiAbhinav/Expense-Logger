import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  color: Colors.black26,
  fontFamily: 'OpenSans',
  fontSize: 16.0,
);

final kLabelStyle = TextStyle(
  color: Colors.black38,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Color(0xFFFFFFFF),
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);