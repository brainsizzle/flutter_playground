class History {

  List<int> fields = List<int>.generate(81, (int index) => 0);

  @override
  String toString() {
    String result = "";
    for (int i = 0; i < 81; i++) {
      result += fields[i].toString();
      if (i % 9 == 8) {
        result += " - ";
      }
    }
    return result;
  }

  @override
  bool operator ==(Object other) {
    return toString() == other.toString();
  }
}