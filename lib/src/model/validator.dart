import 'package:sudokudart/src/model/field.dart';
import 'package:sudokudart/src/model/puzzle.dart';

enum ResolutionState {
  Invalid,
  ValidComplete,
  ValidIncomplete,
}

ResolutionState validatePuzzle(SudokuPuzzle sudokuPuzzle) {
  if (!isPuzzleValid(sudokuPuzzle)) return ResolutionState.Invalid;

  if (isPuzzleComplete(sudokuPuzzle)) return ResolutionState.ValidComplete;

  return ResolutionState.ValidIncomplete;
}

bool isPuzzleComplete(SudokuPuzzle sudokuPuzzle) {
  for (int i = 0; i < 81; i++) {
    if (sudokuPuzzle.fields[i].value == 0) return false;
  }
  return true;
}

bool isPuzzleValid(SudokuPuzzle sudokuPuzzle) {
  for (int i = 0; i < 9; i++) {
    if (!isRowValid(sudokuPuzzle, i)) return false;
    if (!isColValid(sudokuPuzzle, i)) return false;
    if (!isBlockValid(sudokuPuzzle, i)) return false;
  }
  return true;
}

bool isRowValid(SudokuPuzzle sudokuPuzzle, int rowNum) {
  List<SudokuField> fields = sudokuPuzzle.getRow(rowNum);
  return !hasDuplicates(fields);
}

bool isBlockValid(SudokuPuzzle sudokuPuzzle, int blockNum) {
  List<SudokuField> fields = sudokuPuzzle.getBlock(blockNum);
  return !hasDuplicates(fields);
}

bool isColValid(SudokuPuzzle sudokuPuzzle, int colNum) {
  List<SudokuField> fields = sudokuPuzzle.getCol(colNum);
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