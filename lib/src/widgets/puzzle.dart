import 'package:flutter/material.dart';
import 'package:sudokudart/src/model/model.dart';

class ValueDisplay extends StatelessWidget {
  ValueDisplay({Key key, SudokuField value}) : super(key: key) {
    this.text = value.getValueAsText();
    this.fieldColor = value.getColor();
  }

  String text;
  Color fieldColor;

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          print("Tapped a Container");
        },
        child: Container(
            padding: EdgeInsets.all(1),
            child: Container(
                padding: EdgeInsets.only(top: 10),
                width: 48.0,
                height: 48.0,
                decoration: new BoxDecoration(
                    color: fieldColor,
                    borderRadius: new BorderRadius.all(
                      const Radius.circular(10.0),
                    )),
                child: (Text(
                  '$text',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5,
                )))));
  }
}
