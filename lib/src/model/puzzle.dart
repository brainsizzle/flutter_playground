import 'package:sudokudart/src/model/field.dart';

class SudokuPuzzle {
  List<SudokuField> fields = List<SudokuField>.generate(81, (int index) => SudokuField());

  int selectedFieldIndex = 0;

  SudokuPuzzle() {

    // todo import from string
    fields[2].value = 8;
    fields[9].value = 4;
    fields[10].value = 1;
    fields[12].value = 6;
    fields[15].value = 7;
    fields[16].value = 9;
    fields[18].value = 6;
    fields[25].value = 4;
    fields[26].value = 8;

    fields[28].value = 9;
    fields[30].value = 3;
    fields[36].value = 8;
    fields[40].value = 9;
    fields[41].value = 5;
    fields[42].value = 2;
    fields[46].value = 3;
    fields[47].value = 6;
    fields[49].value = 2;
    fields[50].value = 1;
    fields[52].value = 5;

    fields[59].value = 7;
    fields[62].value = 3;
    fields[64].value = 5;
    fields[69].value = 8;
    fields[77].value = 2;
    fields[80].value = 9;

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
    print("checking puzzle");
    resetWarnings();
    markInvalidRows();
    markInvalidCols();
    markInvalidBlocks();

    resetPossibleValues();
    removeImpossibleValuesForRows();
    removeImpossibleValuesForCols();
    removeImpossibleValuesForBlocks();
  }


  void resetWarnings() {
    for (final field in fields) {
      field.status = Status.normal;
    }
  }

  void markInvalidBlocks() {
    for (int blockNum = 0; blockNum < 9; blockNum++) {
      bool valid = isBlockValid(blockNum);
      if (!valid) {
        setStatusForBlock(blockNum, Status.warning);
      }
    }
  }

  void markInvalidRows() {
    for (int rowNum = 0; rowNum < 9; rowNum++) {
      bool valid = isRowValid(rowNum);
      if (!valid) {
        setStatusForRow(rowNum, Status.warning);
      }
    }
  }

  void markInvalidCols() {
    for (int colNum = 0; colNum < 9; colNum++) {
      bool valid = isColValid(colNum);
      if (!valid) {
        setStatusForCol(colNum, Status.warning);
      }
    }
  }

  bool isRowValid(int rowNum) {
    List<SudokuField> fields = getRow(rowNum);
    return !hasDuplicates(fields);
  }

  bool isBlockValid(int blockNum) {
    List<SudokuField> fields = getBlock(blockNum);
    return !hasDuplicates(fields);
  }

  bool isColValid(int colNum) {
    List<SudokuField> fields = getCol(colNum);
    return !hasDuplicates(fields);
  }

  bool hasDuplicates(List<SudokuField> fields) {
    List<int> occurrences = List.filled(9, 0);
    for (SudokuField field in fields) {
      int value = field.value;
      if (value > 0) {
        occurrences[value - 1]++;
      }
    }
    for (int counter in occurrences) {
      if (counter > 1) {
        return true;
      }
    }
    return false;
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
    if (selectedFieldIndex % 9 == 8) {
      selectedFieldIndex -= 8;
    } else {
      selectedFieldIndex++;
    }
  }

  void moveSelectionLeft() {
    if (selectedFieldIndex % 9 == 0) {
      selectedFieldIndex += 8;
    } else {
      selectedFieldIndex--;
    }
  }

  void moveSelectionUp() {
    if (selectedFieldIndex < 9) {
      selectedFieldIndex = 72 + selectedFieldIndex;
    } else {
      selectedFieldIndex -= 9;
    }
  }

  void moveSelectionDown() {
    if (selectedFieldIndex >= 72) {
      selectedFieldIndex -= 72;
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
}