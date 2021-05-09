import 'package:sudokudart/src/model/field.dart';
import 'package:sudokudart/src/model/puzzle.dart';
import 'package:sudokudart/src/model/validator.dart';
import 'package:sudokudart/src/solver/Branch.dart';
import 'package:sudokudart/src/solver/logicsolver.dart';

String solveBruteForce(SudokuPuzzle sudokuPuzzle) {
  // try with simple hint calculator
  solveUntilNoFurtherIdeas(sudokuPuzzle);

  ResolutionState resolution = validatePuzzle(sudokuPuzzle);
  List<SudokuPuzzle> solutions =[];
  switch (resolution)
  {
    case ResolutionState.ValidImpossibleToSolve:
    case ResolutionState.Invalid:
    case ResolutionState.ValidComplete:
      break;
    case ResolutionState.ValidIncomplete:
      Branch branch = createBranch(sudokuPuzzle);
      checkBranchSolutionRecursive(branch, solutions);
      break;
  }
  if (solutions.length == 0)  {
    return "no solution exists";
  }
  if (solutions.length >= 1) {
    sudokuPuzzle.setState(solutions[0].buildHistory());
    sudokuPuzzle.checkPuzzle();
    if (solutions.length == 1) {
      return "found 1 solution";
    }
    if (solutions.length >= 1) {
      return "multiple solutions exist";
    }
  }
}


void checkBranchSolutionRecursive(Branch branch, List<SudokuPuzzle> solutions) {
  if (solutions.length > 1) return;
  CheckState branchState = branch.calculateBranchState();
  while (CheckState.Open == branchState && solutions.length < 2)
  {
    checkBranch(branch, solutions);
    Guess guess = branch.getFirstOpenGuess();

    if (guess != null) {
      // follow the branch
      if (guess.childBranch != null) {
        // print("child   " + guess.childBranch.toString());
        // guess state must be reflected
        checkBranchSolutionRecursive(guess.childBranch, solutions);
      } else {
        checkGuess(branch, guess, solutions);
      }
      guess.recalcState();
      branchState = branch.calculateBranchState();
    } else {
      return;
    }
  }
}

Branch createBranch(SudokuPuzzle sudokuPuzzle) {
  SudokuField guessLocation = getNextEmtpyLocation(sudokuPuzzle);
  Branch branch = new Branch(state: sudokuPuzzle.buildHistory(), guessLocation: guessLocation.index);

  for (int possibleValue in guessLocation.possibleValues)
  {
    branch.guesses.add( new Guess(possibleValue));
  }
  return branch;
}

SudokuField getNextEmtpyLocation(SudokuPuzzle sudokuPuzzle) {
  for (int i = 0; i < 81; i++) {
    if (sudokuPuzzle.fields[i].value == 0) {
      return sudokuPuzzle.fields[i];
    }
  }
  return null;
}

CheckState checkBranch(Branch branch, List<SudokuPuzzle> solutions) {
  for (Guess guess in branch.guesses) {
    checkGuess(branch, guess, solutions);
  }
  return branch.calculateBranchState();
}

void checkGuess(Branch branch, Guess guess, List<SudokuPuzzle> solutions) {
  if (guess.guessState == CheckState.Open)
  {
    SudokuPuzzle testPuzzle = new SudokuPuzzle();
    testPuzzle.setState(branch.state);

    SudokuField sudokuField = testPuzzle.fields[branch.guessLocation];
    sudokuField.value = guess.guessValue;

    testPuzzle.checkPuzzle();
    solveUntilNoFurtherIdeas(testPuzzle);
    ResolutionState resolution = validatePuzzle(testPuzzle);

    switch (resolution)
    {
      case ResolutionState.ValidImpossibleToSolve:
        guess.guessState = CheckState.CompletelyChecked;
        break;
      case ResolutionState.ValidComplete:
        guess.guessState = CheckState.CompletelyChecked;
        // print("solved  " + testPuzzle.buildHistory().toString());
        solutions.add(testPuzzle);
        break;
      case ResolutionState.ValidIncomplete:
        guess.guessState = CheckState.Open;
        guess.childBranch = createBranch(testPuzzle);
        break;
      case ResolutionState.Invalid:
        guess.guessState = CheckState.CompletelyChecked;
        break;
    }
  }
}