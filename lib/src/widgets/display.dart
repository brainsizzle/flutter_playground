import 'package:flutter/material.dart';
import 'package:sudokudart/src/model/field.dart';
import 'package:sudokudart/src/model/puzzle.dart';

class ValueDisplay extends StatelessWidget {
  ValueDisplay(
      {Key key, this.text, this.fieldColor, this.onClicked, this.index, this.selected = false})
      : super(key: key);

  final String text;
  final Color fieldColor;
  final ValueChanged<int> onClicked;
  final int index;
  final bool selected;

  void _handleTap() {
    onClicked(index);
  }

  @override
  @override
  Widget build(BuildContext context) {
    var borderColor = fieldColor;
    if (selected) {
      borderColor = Colors.redAccent;
    }
    return GestureDetector(
        onTap: _handleTap,
        child: Container(

            padding: EdgeInsets.all(1),
            child: Container(
                padding: EdgeInsets.only(top: 8),
                width: 48.0,
                height: 48.0,
                decoration: new BoxDecoration(
                    color: fieldColor,
                    border: Border.all(
                      color: borderColor,
                      width: 3,
                    ),
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

class TripleRow extends Table {
  TripleRow({Key key, this.sudokuPuzzle, this.startingIndex, this.onClicked})
      : super(key: key);

  final SudokuPuzzle sudokuPuzzle;
  final int startingIndex;
  final ValueChanged<int> onClicked;

  @override
  List<RowDisplay> get children =>List<RowDisplay>.generate(
      3,
          (rowNum) => new RowDisplay(
          sudokuPuzzle: sudokuPuzzle,
          startingIndex: startingIndex + sudokuPuzzle.getRowStartingIndex(rowNum),
          numberOfFields: 3,
          onClicked: onClicked));
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
      return Colors.blue[100];
    }
    switch (status) {
      case Status.normal:
        return Colors.blue[100];
        break;
      case Status.warning:
        return Colors.orange[200];
        break;
    }
    return Colors.blue[100];
  }

  static String getValueAsText(int value) {
    if (value > 0) {
      return value.toString();
    }
    return "";
  }

  @override
  List<Widget> get children => List.generate(
      numberOfFields,
      (index) => new ValueDisplay(
            text: getValueAsText(sudokuPuzzle.getField(index+startingIndex).value),
            fieldColor: getColorForStatus(sudokuPuzzle.getField(index+startingIndex).getStatus()),
            index: startingIndex + index,
            onClicked: _onClicked,
            selected: sudokuPuzzle.isSelected(index+startingIndex),
          ));
}
