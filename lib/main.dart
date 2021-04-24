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

  void _fieldClicked(int index) {
    setState(() {
      puzzle.selectField(index);
    });
  }

  void _buttonClicked(String value) {
    setState(() {
      if (value == "X") {
        puzzle.resetSelectedField();
      } else {
        puzzle.setSelectedValue(int.parse(value));
      }
      puzzle.checkPuzzle();
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
                        onClicked: _fieldClicked))),
            Spacer(),
            Table(
              children: [
                TableRow(
                  children: [
                    TypeValueButton(value: "1", onClicked: _buttonClicked),
                    TypeValueButton(value: "2", onClicked: _buttonClicked),
                    TypeValueButton(value: "3", onClicked: _buttonClicked),
                    TypeValueButton(value: "4", onClicked: _buttonClicked),
                    TypeValueButton(value: "5", onClicked: _buttonClicked),
                  ],
                ),
                TableRow(
                  children: [
                    TypeValueButton(value: "6", onClicked: _buttonClicked),
                    TypeValueButton(value: "7", onClicked: _buttonClicked),
                    TypeValueButton(value: "8", onClicked: _buttonClicked),
                    TypeValueButton(value: "9", onClicked: _buttonClicked),
                    TypeValueButton(value: "X", onClicked: _buttonClicked),
                  ],
                ),
              ],),
            Padding(padding: EdgeInsets.only(bottom: 10.0)),
          ],
        ),
      ),
    );
  }
}
