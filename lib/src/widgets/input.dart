import 'package:flutter/material.dart';

class TypeValueButton extends Container {

  TypeValueButton(this.value)  : super(padding: EdgeInsets.all(2.5));

  final String value;

  @override
  Widget get child => TextButton(
      onPressed: () {},
      child: Text(value),
      style:  TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Colors.grey[700],
        // padding: EdgeInsets.all(10.0),
      ));

}