import 'package:sudokudart/src/model/history.dart';

class Branch {

  Branch({this.state, this.guessLocation});

  History state;

  int guessLocation;

  List<Guess> guesses = [];
  CheckState branchState = CheckState.Open;
}

class Guess {

  Guess(this.guessValue);

  Branch childBranch;
  CheckState guessState = CheckState.Open;
  int guessValue;
}

enum CheckState {
  Open,
  CompletelyChecked,
}