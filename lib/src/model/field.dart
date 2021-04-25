enum Status {
  normal,
  warning,
}

class SudokuField {
  int value = 0;
  Status status = Status.normal;
  List<int> possibleValues = [1,2,3,4,5,6,7,8,9];

  Status getStatus() {
    return status;
  }

  void incrementValue() {
    if (value == 9) {
      value = 0;
    } else {
      value++;
    }
  }
}