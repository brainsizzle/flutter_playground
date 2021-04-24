import 'package:sudokudart/src/model/field.dart';

class SudokuPuzzle {
  List<SudokuField> fields =
  List<SudokuField>.generate(81, (int index) => SudokuField());

  int selectedFieldIndex = 0;

  SudokuPuzzle() {
    fields[0].value = 3;
    fields[5].value = 2;
    fields[15].value = 2;
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
    return [
      fields[colNum + 0 * 9],
      fields[colNum + 1 * 9],
      fields[colNum + 2 * 9],
      fields[colNum + 3 * 9],
      fields[colNum + 4 * 9],
      fields[colNum + 5 * 9],
      fields[colNum + 6 * 9],
      fields[colNum + 7 * 9],
      fields[colNum + 8 * 9],
    ];
  }

  int getIndex(int rowNum, int colNum) {
    return colNum + 9 * rowNum;
  }

  List<SudokuField> getBlock(int blockNum) {
    int startingRow = 0;
    if (blockNum >= 3) {
      startingRow = 3;
    }
    if (blockNum >= 6) {
      startingRow = 6;
    }

    int startingCol = 0;
    if (blockNum == 1 || blockNum == 4|| blockNum == 7) {
      startingCol = 3;
    } else if (blockNum == 2 || blockNum == 5|| blockNum == 8) {
      startingCol = 6;
    }

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
}