import 'package:flutter/material.dart';
import 'package:sudokudart/src/model/field.dart';
import 'package:sudokudart/src/model/puzzle.dart';

class ValueDisplay extends StatelessWidget {

  ValueDisplay(
      {Key key, this.value, this.fieldColor, this.borderColor, this.onClicked, this.index, this.selected = false, this.possibleValues})
      : super(key: key);

  final int value;
  final Color fieldColor;
  final Color borderColor;
  final ValueChanged<int> onClicked;
  final int index;
  final bool selected;
  final List<int> possibleValues;

  void _handleTap() {
    onClicked(index);
  }

  Widget _getSingleNum(int num) {

    String _text = possibleValues.contains(num) ? num.toString() : "";

    return Center(
        child: Text(
          _text,
          textScaleFactor: 0.8,
          style: TextStyle(color: Colors.grey[600]),
        ));
  }

  static String getValueAsText(int value) {
    if (value > 0) {
      return value.toString();
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    Color _borderColor = borderColor;
    double _borderWidth = 1.0;

    if (selected) {
      _borderColor = Colors.redAccent;
      _borderWidth = 3.0;
    }

    var widgetToDisplay;
    if (value > 0) {
      widgetToDisplay = Center( child: Text(
        getValueAsText(value),
        textAlign: TextAlign.center,
        textScaleFactor: 2.8,
        style: TextStyle(color: Colors.grey[900]),
      ));
    } else {
      widgetToDisplay = Center( child: Table(
        children: [
          TableRow(
            children: [ _getSingleNum(1), _getSingleNum(2), _getSingleNum(3) ],
          ),
          TableRow(
            children: [ _getSingleNum(4), _getSingleNum(5), _getSingleNum(6) ],
          ),
          TableRow(
            children: [ _getSingleNum(7), _getSingleNum(8), _getSingleNum(9) ],
          ),
        ],
      ));
    };

    return GestureDetector(
        onTap: _handleTap,
        child: Container(
            padding: EdgeInsets.all(1),
            child: Container(
              // padding: EdgeInsets.only(top: 8),
                width: 48.0,
                height: 48.0,
                decoration: new BoxDecoration(
                    color: fieldColor,
                    border: Border.all(
                      color: _borderColor,
                      width: _borderWidth,
                    ),
                    borderRadius: new BorderRadius.all(
                      const Radius.circular(5.0),
                    )),
                child: widgetToDisplay))
    );
  }
}

class RowDisplay extends TableRow {
  RowDisplay({Key key, this.sudokuPuzzle, this.startingIndex, this.numberOfFields, this.onClicked})
      : super(key: key);

  final SudokuPuzzle sudokuPuzzle;
  final int startingIndex;
  final int numberOfFields;
  final ValueChanged<int> onClicked;

  void _onClicked(int index) {
    onClicked(index);
  }

  static Color getColorForStatus(Status status) {
    if (status == null) {
      return Colors.blue[50];
    }
    switch (status) {
      case Status.normal:
        return Colors.blue[50];
        break;
      case Status.warning:
        return Colors.orange[200];
        break;
    }
    return Colors.blue[50];
  }

  static getBorderColorForField(int index)
  {
    int block = SudokuPuzzle.getBlockNumForIndex(index);
    if(block % 2 == 1) {
      return Colors.grey[400];
    }
    return Colors.grey[800];
  }

  @override
  List<Widget> get children => List.generate(
      numberOfFields,
          (index) => new ValueDisplay(
        value: sudokuPuzzle.getField(index+startingIndex).value,
        possibleValues:  sudokuPuzzle.getField(index+startingIndex).possibleValues,
        fieldColor: getColorForStatus(sudokuPuzzle.getField(index+startingIndex).getStatus()),
        borderColor: getBorderColorForField(index+startingIndex),
        index: startingIndex + index,
        onClicked: _onClicked,
        selected: sudokuPuzzle.isSelected(index+startingIndex),
      ));
}
