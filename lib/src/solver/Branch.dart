import 'package:sudokudart/src/model/history.dart';

class Branch {

  Branch({this.state, this.guessLocation});

  History state;

  int guessLocation;

  List<Guess> guesses = [];
  CheckState branchState = CheckState.Open;

  CheckState calculateBranchState() {
    branchState = CheckState.Open;
    for (Guess guess in guesses)
    {
      switch (guess.guessState)
      {
        case CheckState.Open:
        // any is open -> all is open
          return branchState;
        case CheckState.CompletelyChecked:
          break;
      }
    }
    branchState = CheckState.CompletelyChecked;
    return branchState;

  }

  Guess getFirstOpenGuess() {
    for (Guess guess in guesses) {
      switch (guess.guessState)
      {
        case CheckState.Open:
        // recursive
          return guess;
        case CheckState.CompletelyChecked:
          break;
      }
    }
    return null;
  }

  @override
  String toString() {
    return state.toString();
  }
}

class Guess {

  Guess(this.guessValue);

  Branch childBranch;
  CheckState guessState = CheckState.Open;
  int guessValue;

  // checks whether all child branches are closed
  void recalcState()
  {
    if (CheckState.Open == guessState && childBranch != null)
    {
      switch (childBranch.branchState) {
        case CheckState.CompletelyChecked:
          int complete = 0;
          for (Guess childGuess in childBranch.guesses) {
            switch (childGuess.guessState) {
              case CheckState.Open:
                break;
              case CheckState.CompletelyChecked:
                complete++;
                break;
            }
          }
          if ( complete == childBranch.guesses.length)
          {
            guessState = CheckState.CompletelyChecked;
          }
          break;
        case CheckState.Open:
          break;
      }
    }
  }
}

enum CheckState {
  Open,
  CompletelyChecked,
}