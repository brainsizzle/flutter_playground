import 'package:flutter/material.dart';

class TypeValueButton extends Container {

  TypeValueButton({this.value="X", this.onClicked = _noop})  : super(padding: EdgeInsets.all(2.5));

  final String value;
  final ValueChanged<String> onClicked;

  static void _noop(String arg) {
    print("click not passed on: " + arg);
  }

  @override
  Widget get child => TextButton(
      onPressed: () {
        onClicked(value);
      },
      child: Text(value),
      style:  TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Colors.grey[700],
        // padding: EdgeInsets.all(10.0),
      ));

}