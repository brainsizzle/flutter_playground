import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sudokudart/src/model/puzzle.dart';
import 'package:sudokudart/src/widgets/display.dart';
import 'package:sudokudart/src/widgets/input.dart';

void main() {
  runApp(SuduokuSolver());
}

class SuduokuSolver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sudoku Solver',
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.lightBlueAccent,
      ),
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
      puzzle.selectField(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Table(
                children: List<RowDisplay>.generate(
                    9,
                        (rowNum) => new RowDisplay(
                        sudokuPuzzle: puzzle,
                        startingIndex: puzzle.getRowStartingIndex(rowNum),
                        numberOfFields: 9,
                        onClicked: _onClicked))),
            Spacer(),
            Table(
              children: [
                TableRow(
                  children: [
                    Spacer(),
                    TypeValueButton("1"),
                    TypeValueButton("2"),
                    TypeValueButton("3"),
                    TypeValueButton("4"),
                    TypeValueButton("5"),
                    Spacer(),
                  ],
                ),
                TableRow(
                  children: [
                    Spacer(),
                    TypeValueButton("6"),
                    TypeValueButton("7"),
                    TypeValueButton("8"),
                    TypeValueButton("9"),
                    TypeValueButton("X"),
                    Spacer(),
                  ],
                ),
              ],),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _checkSudoku,
        tooltip: 'check state',
        child: Icon(Icons.add),
      ),
    );
  }
}
