class History {

  List<int> fields = List<int>.generate(81, (int index) => 0);

  @override
  String toString() {
    String result = "";
    for (int i = 0; i < 81; i++) {
      if (fields[i] > 0) {
        result += fields[i].toString();
      } else {
        result += ".";
      }
      if (i % 9 == (9 - 1) && i < 81 -1) {
        result += "-";
      }
    }
    return result;
  }

  void fromString(String input) {
    int index = 0;
    for(int rune in input.runes) {
      int intValue1 = '1'.runes.first;
      if (rune >= intValue1 && rune <= '9'.runes.first) {
        fields[index] = rune - intValue1 + 1;
        index++;
      } else if ("-".runes.first == rune) {
        // fields[index] = 4;
        // index++;
      } else {
        fields[index] = 0;
        index++;
      }

      if (index == 81) break;
    }
  }

  @override
  bool operator ==(Object other) {
    return toString() == other.toString();
  }
}