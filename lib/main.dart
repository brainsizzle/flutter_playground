import 'package:flutter/material.dart';
import 'package:sudokudart/src/model/puzzle.dart';
import 'package:sudokudart/src/model/field.dart';
import 'package:sudokudart/src/widgets/display.dart';

void main() {
  runApp(SuduokuSolver());
}

class SuduokuSolver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku Solver',
      theme: ThemeData(
          primarySwatch: Colors.green, accentColor: Colors.lightBlueAccent),
      home: MainPage(title: 'Sudoku Solver'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SudokuPuzzle puzzle = new SudokuPuzzle();

  void _checkSudoku() {
    setState(() {
      puzzle.checkPuzzle();
    });
  }

  void _onClicked(int index) {
    setState(() {
      puzzle.incrementValue(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Table(
            children: List<RowDisplay>.generate(
                9,
                (rowNum) => new RowDisplay(
                    values: puzzle.getRow(rowNum),
                    startingIndex: puzzle.getStartingIndex(rowNum),
                    onClicked: _onClicked))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _checkSudoku,
        tooltip: 'check state',
        child: Icon(Icons.add),
      ),
    );
  }
}
