import 'package:flutter/material.dart';

class SudokuPuzzle {
  List<SudokuField> allInitialFields =
      List<SudokuField>.generate(81, (int index) => SudokuField());

  SudokuPuzzle() {
    allInitialFields[0].value = 3;
    allInitialFields[5].value = 2;
    allInitialFields[15].value = 2;
  }

  List<SudokuField> getRow(int rowNum) {
    return allInitialFields.sublist(rowNum * 9, (rowNum + 1) * 9);
  }
}

class SudokuField {
  int value = 0;
  Color color = Colors.blue[100];

  String getValueAsText() {
    if (value > 0) {
      return value.toString();
    }
    return "";
  }

// todo this should be an enum
  Color getColor() {
    return color;
  }
}
