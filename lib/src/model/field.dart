enum Status {
  normal,
  warning,
}

class SudokuField {
  int value = 0;
  Status status = Status.normal;

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

  bool isSelected() {

  }
}