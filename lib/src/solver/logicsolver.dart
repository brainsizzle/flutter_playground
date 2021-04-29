import 'package:sudokudart/src/model/field.dart';
import 'package:sudokudart/src/model/puzzle.dart';

String solveField(SudokuPuzzle sudokuPuzzle) {

  int indexFound = -1;

  indexFound = findOnlyOccurrenceInBlock(sudokuPuzzle);
  if (indexFound >= 0) {
    sudokuPuzzle.checkPuzzle();
    sudokuPuzzle.selectedFieldIndex = indexFound;
    return "Only occurence in block!";
  }

  indexFound = findOnlyOccurrenceInColumn(sudokuPuzzle);
  if (indexFound >= 0) {
    sudokuPuzzle.checkPuzzle();
    sudokuPuzzle.selectedFieldIndex = indexFound;
    return "Only occurence in column!";
  }

  indexFound = findOnlyOccurrenceInRow(sudokuPuzzle);
  if (indexFound >= 0) {
    sudokuPuzzle.checkPuzzle();
    sudokuPuzzle.selectedFieldIndex = indexFound;
    return "Only occurence in row!";
  }

  indexFound = findFieldWithOnlyOnePossibleValue(sudokuPuzzle);
  if (indexFound >= 0) {
    sudokuPuzzle.checkPuzzle();
    sudokuPuzzle.selectedFieldIndex = indexFound;
    return "Only one possible value!";
  }
  return "No idea!";
}

int findOnlyOccurrenceInRow(SudokuPuzzle sudokuPuzzle) {
  for (int rowNum = 0; rowNum < 9; rowNum++) {
    // find missing values in row
    List<SudokuField> fieldsToCheck = sudokuPuzzle.getRow(rowNum);
    int rowResult = findOnlyOccurrenceInFields(fieldsToCheck);
    if (rowResult >= 0) return rowResult;
  }
  return -1;
}

int findOnlyOccurrenceInColumn(SudokuPuzzle sudokuPuzzle) {
  for (int colNum = 0; colNum < 9; colNum++) {
    // find missing values in row
    List<SudokuField> fieldsToCheck = sudokuPuzzle.getCol(colNum);
    int rowResult = findOnlyOccurrenceInFields(fieldsToCheck);
    if (rowResult >= 0) return rowResult;
  }
  return -1;
}
int findOnlyOccurrenceInBlock(SudokuPuzzle sudokuPuzzle) {
  for (int blockNum = 0; blockNum < 9; blockNum++) {
    // find missing values in row
    List<SudokuField> fieldsToCheck = sudokuPuzzle.getBlock(blockNum);
    int rowResult = findOnlyOccurrenceInFields(fieldsToCheck);
    if (rowResult >= 0) return rowResult;
  }
  return -1;
}

int findOnlyOccurrenceInFields(List<SudokuField> fieldsToCheck) {

  // count occurrences of missing values in row
  List<int> missingValues = findMissingValues(fieldsToCheck);
  // check if any occurrence is 1
  for (int missingValue in missingValues) {
    int timesFound = 0;
    for (SudokuField field in fieldsToCheck) {
      if (field.possibleValues.contains(missingValue)) {
        timesFound++;
      }
    }
    if (timesFound == 1) {
      SudokuField fieldWithPossibleValue = findFirstFieldWithPossibleValue(fieldsToCheck, missingValue);
      fieldWithPossibleValue.value = missingValue;
      return fieldWithPossibleValue.index;
    }
  }
  return -1;
}

SudokuField findFirstFieldWithPossibleValue(List<SudokuField> fields, int value) {
  for (SudokuField field in fields) {
    if (field.possibleValues.contains(value)) {
      return field;
    }
  }
  return null;
}

List<int> findMissingValues(List<SudokuField> fields) {
  // todo unit test
  List<int> allPossibleValues = [1,2,3,4,5,6,7,8,9];
  for (SudokuField field in fields) {
    if (field.value > 0) {
      allPossibleValues.remove(field.value);
    }
  }
  return allPossibleValues;
}

int findFieldWithOnlyOnePossibleValue(SudokuPuzzle sudokuPuzzle) {
  int indexFound = -1;
  for (int index = 0; index < 81; index++) {
    SudokuField field = sudokuPuzzle.fields[index];
    if (field.value == 0 &&  field.possibleValues.length == 1) {
      field.value = field.possibleValues[0];
      indexFound = index;
      break;
    }
  }
  return indexFound;
}