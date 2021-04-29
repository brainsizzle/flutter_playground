import 'package:sudokudart/src/model/field.dart';
import 'package:sudokudart/src/model/history.dart';
import 'package:sudokudart/src/model/validator.dart';

class SudokuPuzzle {

  List<SudokuField> fields = List<SudokuField>.generate(81, (int index) => SudokuField(index));

  int selectedFieldIndex = 0;

  List<History> previousStates = [];

  SudokuPuzzle() {

    History history = new History();
    // history.fromString("..8......-41.6..79.-6......48-.9.3.....-8...952..-.36.21.5.-.....7..3-.5....8..-.....2..9");
    // history.fromString("9.8...615-413658792-6.5..9348-5923..187-841795236-736821954-.....7..3-.5....8.1-.....2..9");
    // history.fromString("928473615-413658792-675219348-592346187-841795236-736821954-169587423-257934861-384162579");
    // history.fromString("928473615-413658792-675219348-592346187-841795236-736821954-189567423-257934861-364182579");
    // setState(history);
  }

  int getRowStartingIndex(int rowNum) {
    return rowNum * 9;
  }

  void incrementValue(int index) {
    fields[index].incrementValue();
  }

  List<SudokuField> getRow(int rowNum) {
    return fields.sublist(rowNum * 9, (rowNum + 1) * 9);
  }

  List<SudokuField> getCol(int colNum) {
    return List.generate(9, (index) => fields[colNum + index * 9]);
  }

  int getIndex(int rowNum, int colNum) {
    return colNum + 9 * rowNum;
  }

  static int getBlockNumForIndex(int index) {
    // i am sure there is an algorithm for this

    if (index < 3) return 0;
    if (index < 6) return 1;
    if (index < 9) return 2;

    if (index < 12) return 0;
    if (index < 15) return 1;
    if (index < 18) return 2;

    if (index < 21) return 0;
    if (index < 24) return 1;
    if (index < 27) return 2;

    if (index < 30) return 3;
    if (index < 33) return 4;
    if (index < 36) return 5;

    if (index < 39) return 3;
    if (index < 42) return 4;
    if (index < 45) return 5;

    if (index < 48) return 3;
    if (index < 51) return 4;
    if (index < 54) return 5;

    if (index < 57) return 6;
    if (index < 60) return 7;
    if (index < 63) return 8;

    if (index < 66) return 6;
    if (index < 69) return 7;
    if (index < 72) return 8;

    if (index < 75) return 6;
    if (index < 78) return 7;

    return 8;
  }

  List<SudokuField> getBlock(int blockNum) {
    int startingRow = 0;
    if (blockNum >= 3) {
      startingRow = 3;
    }
    if (blockNum >= 6) {
      startingRow = 6;
    }

    int startingCol = blockNum % 3 * 3;

    return [
      fields[getIndex(startingRow, startingCol)],
      fields[getIndex(startingRow +1, startingCol)],
      fields[getIndex(startingRow +2, startingCol)],

      fields[getIndex(startingRow, startingCol + 1)],
      fields[getIndex(startingRow +1, startingCol + 1)],
      fields[getIndex(startingRow +2, startingCol + 1)],

      fields[getIndex(startingRow, startingCol + 2)],
      fields[getIndex(startingRow +1, startingCol + 2)],
      fields[getIndex(startingRow +2, startingCol + 2)],
    ];
  }

  void checkPuzzle() {
    resetWarnings();
    markInvalidRows();
    markInvalidCols();
    markInvalidBlocks();

    resetPossibleValues();
    removeImpossibleValuesForRows();
    removeImpossibleValuesForCols();
    removeImpossibleValuesForBlocks();

    addHistory();
  }


  void resetWarnings() {
    for (final field in fields) {
      field.status = Status.normal;
    }
  }

  void markInvalidBlocks() {
    for (int blockNum = 0; blockNum < 9; blockNum++) {
      bool valid = isBlockValid(this, blockNum);
      if (!valid) {
        setStatusForBlock(blockNum, Status.warning);
      }
    }
  }

  void markInvalidRows() {
    for (int rowNum = 0; rowNum < 9; rowNum++) {
      bool valid = isRowValid(this, rowNum);
      if (!valid) {
        setStatusForRow(rowNum, Status.warning);
      }
    }
  }

  void markInvalidCols() {
    for (int colNum = 0; colNum < 9; colNum++) {
      bool valid = isColValid(this, colNum);
      if (!valid) {
        setStatusForCol(colNum, Status.warning);
      }
    }
  }

  void setStatusForBlock(int blockNum, Status status) {
    for (SudokuField field in getBlock(blockNum)) {
      field.status = status;
    }
  }

  void setStatusForRow(int rowNum, Status status) {
    for (SudokuField field in getRow(rowNum)) {
      field.status = status;
    }
  }

  void setStatusForCol(int colNum, Status status) {
    for (SudokuField field in getCol(colNum)) {
      field.status = status;
    }
  }

  SudokuField getField(int index) {
    return fields[index];
  }

  bool isSelected(int index) {
    return index == selectedFieldIndex;
  }

  void selectField(int index) {
    selectedFieldIndex = index;
  }

  void resetSelectedField() {
    getSelectedField().value = 0;
  }

  SudokuField getSelectedField() {
    return fields[selectedFieldIndex];
  }

  void setSelectedValue(int value) {
    getSelectedField().value = value;
  }

  void moveSelectionRight() {
    if (selectedFieldIndex % 9 == (9-1)) {
      selectedFieldIndex -= (9 - 1);
    } else {
      selectedFieldIndex++;
    }
  }

  void moveSelectionLeft() {
    if (selectedFieldIndex % 9 == 0) {
      selectedFieldIndex += (9 - 1);
    } else {
      selectedFieldIndex--;
    }
  }

  void moveSelectionUp() {
    if (selectedFieldIndex < 9) {
      selectedFieldIndex = (9 * (9 - 1)) + selectedFieldIndex;
    } else {
      selectedFieldIndex -= 9;
    }
  }

  void moveSelectionDown() {
    if (selectedFieldIndex >= 9) {
      selectedFieldIndex -= (9 * (9 - 1));
    } else {
      selectedFieldIndex += 9;
    }
  }

  void resetPossibleValues() {
    for (SudokuField sudokuField in fields) {
      sudokuField.resetPossibleValues();
    }
  }

  void removeImpossibleValuesForRows() {
    for (int rowNum = 0; rowNum < 9; rowNum++) {
      List<SudokuField> fields = getRow(rowNum);
      Set<int> usedValues = new Set();
      for (SudokuField field in fields) {
        usedValues.add(field.value);
      }
      for (SudokuField field in fields) {
        for(int usedValue in usedValues) {
          field.removePossibleValue(usedValue);
        }
      }
    }
  }

  void removeImpossibleValuesForCols() {
    for (int colNum = 0; colNum < 9; colNum++) {
      List<SudokuField> fields = getCol(colNum);
      Set<int> usedValues = new Set();
      for (SudokuField field in fields) {
        usedValues.add(field.value);
      }
      for (SudokuField field in fields) {
        for(int usedValue in usedValues) {
          field.removePossibleValue(usedValue);
        }
      }
    }
  }

  void removeImpossibleValuesForBlocks() {
    for (int blockNum = 0; blockNum < 9; blockNum++) {
      List<SudokuField> fields = getBlock(blockNum);
      Set<int> usedValues = new Set();
      for (SudokuField field in fields) {
        usedValues.add(field.value);
      }
      for (SudokuField field in fields) {
        for(int usedValue in usedValues) {
          field.removePossibleValue(usedValue);
        }
      }
    }
  }

  void addHistory() {
    History newEntry = buildHistory();
    if (previousStates.length == 0 || previousStates.last != newEntry) {
      print("history " + newEntry.toString());
      previousStates.add(newEntry);
    }
  }

  History buildHistory() {
     History newEntry = History();
    for (SudokuField field in fields) {
      newEntry.fields[field.index] = field.value;
    }
    return newEntry;
  }

  String goToPrevious() {
    if (previousStates.length <= 1) {
      return "No previous version";
    }
    // forget actual one
    previousStates.removeLast();
    History newStateToBe = previousStates.removeLast();
    setState(newStateToBe);

    // will put the state back on
    checkPuzzle();
    return "one step back";
  }

  void setState(History newStateToBe) {
    for (int i = 0; i < 81; i++) {
      fields[i].value = newStateToBe.fields[i];
    }
  }
}