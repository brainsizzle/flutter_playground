import 'package:sudokudart/src/model/field.dart';
import 'package:sudokudart/src/model/puzzle.dart';
import 'package:sudokudart/src/model/validator.dart';
import 'package:sudokudart/src/solver/Branch.dart';
import 'package:sudokudart/src/solver/logicsolver.dart';

String solveBruteForce(SudokuPuzzle sudokuPuzzle) {
  // try with simple hint calculator
  int found = solveUntilNoFurtherIdeas(sudokuPuzzle);
  print("solved " + found.toString() + " fields with logic");

  ResolutionState resolution = validatePuzzle(sudokuPuzzle);
  List<SudokuPuzzle> solutions =[];
  switch (resolution)
  {
    case ResolutionState.Invalid:
    case ResolutionState.ValidComplete:
      break;
    case ResolutionState.ValidIncomplete:
      Branch branch = createBranch(sudokuPuzzle);
      // checkBranchSolutionRecursive(branch, solutions);
      break;
  }
  return "did some testing " + solutions.length.toString();
}

/*
void checkBranchSolutionRecursive(Branch branch, GlobalSolution globalSolution)
{
  if (globalSolution.getSolutions().size() > 1) return;
  Branch.BranchState branchState = branch.calculateBranchState();
  while (Branch.BranchState.OPEN == branchState && globalSolution.getSolutions().size() < 2)
  {
    checkBranch(branch, globalSolution);
    Guess guess = branch.getFirstOpenGuess();

    if (guess != null)
    {
      // follow the branch

      if (guess.getChildBranch() != null)
      {
        System.out.println(guess.getChildBranch().puzzle);
        // guess state must be reflected
        checkBranchSolutionRecursive(guess.getChildBranch(), globalSolution);
      }
      else
      {
        checkGuess(branch, guess, globalSolution);
      }
      guess.recalcState();
      branchState = branch.calculateBranchState();

    }
    else
    {
      // branch.calculateBranchState();
      return;
    }
  }
}*/

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