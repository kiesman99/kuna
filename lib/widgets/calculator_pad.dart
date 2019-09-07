import 'package:flutter/material.dart';
import 'package:kuna/data/calculator_rows.dart';
import 'package:kuna/provider/calculator_provider.dart';
import 'package:provider/provider.dart';

/// The size of one tile.
/// It is calculated from the [CalculatorPad], which will get the parent constraints
/// via a [LayoutBuilder].
Size _tileSize;

class CalculatorPad extends StatelessWidget {
  /// This variable will provide the actual layout of the CalculatorPad
  List<List<CalculatorTile>> get _calculatorRows =>
      CalculatorRows.calculatorRows;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _tileSize = Size(constraints.maxWidth / _calculatorRows[0].length,
            constraints.maxHeight / _calculatorRows.length);
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[...buildColumns()],
        );
      },
    );
  }

  List<Widget> buildColumns() {
    List<Widget> tmp = new List();

    for (var row in _calculatorRows) {
      tmp.add(_CalculatorRow(row: row));
    }

    return tmp;
  }
}

/// This class will define a single row of a calculator
///
/// It will render it's Elements based on the [row] given to it
class _CalculatorRow extends StatelessWidget {
  final List<CalculatorTile> row;

  //final double tileSize;

  _CalculatorRow({
    @required this.row,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[...buildRow()],
    );
  }

  /// This function will build the rows needed for the GridView
  List<Widget> buildRow() {
    List<Widget> tmp = new List();

    for (var tile in row) {
      tmp.add(new _CalculatorButton.fromCalculatorTile(
        tile: tile,
      ));
    }

    return tmp;
  }
}

/// This is a simple holder class with all the information needed
/// to render a simple [_CalculatorButton]
class CalculatorTile {
  /// The function executed if the [_CalculatorButton] was tapped
  CalculatorAction onTap;

  /// The function executed if the [_CalculatorButton] was long-pressed
  CalculatorAction onLongPress;

  /// The actual Widget rendered in the Center of the [_CalculatorButton]
  Widget child;

  CalculatorTile(
      {@required this.onTap, @required this.child, this.onLongPress});

  /// This constructor will provide an easy access if someone wants to create
  /// a non-clickable Tile inside of the calculator
  CalculatorTile.empty() {
    this.onTap = null;
    this.child = Container();
  }
}

/// A [_CalculatorButton] is used to render a simple button of
/// the calculator
class _CalculatorButton extends StatelessWidget {
  /// The function executed if the [_CalculatorButton] was tapped
  CalculatorAction onTap;

  /// The function executed if the [_CalculatorButton] was long-pressed
  CalculatorAction onLongPress;

  /// The actual Widget rendered in the Center of the [_CalculatorButton]
  Widget child;

  /// If true a empty container will be rendered
  bool empty = false;

  /// The [_CalculatorButton] must have both parameters [tile] and [tileSize]
  ///
  /// The [tile] will hold all information needed to render the button
  _CalculatorButton({
    @required this.onTap,
    @required this.child,
    this.empty,
    this.onLongPress,
  });

  /// Will render a [_CalculatorButton] from the [tile} model
  ///
  /// If the onTap function is empty it will render an empty Container
  _CalculatorButton.fromCalculatorTile(
      {final CalculatorTile tile, double tileSize}) {
    if (tile.onTap == null) this.empty = true;

    this.onTap = tile.onTap;
    this.onLongPress = tile.onLongPress;
    this.child = tile.child;
  }

  /// This will render a simple Container
  ///
  /// It is usefull if someone wants to render a non-clickable tile
  _CalculatorButton.emptyButton() {
    this.empty = true;
  }

  @override
  Widget build(BuildContext context) {
    return empty
        ? Container(
            height: _tileSize.height,
            width: _tileSize.width,
          )
        : Consumer<CalculatorProvider>(
            builder: (context, calcProvider, widget) {
              return Expanded(
                child: Material(
                  color: Theme.of(context).primaryColor,
                  child: InkWell(
                    onTap: onTap == null
                        ? null
                        : () {
                            calcProvider.calcButtonPress(onTap);
                          },
                    onLongPress: onLongPress == null
                        ? null
                        : () {
                            calcProvider.calcButtonPress(onLongPress);
                          },
                    child: Container(
                      height: _tileSize.height,
                      width: _tileSize.width,
                      child: Center(
                        child: child,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}

/// This is a simple holder for all the actions
/// the calculator should be able to complete
enum CalculatorAction {
  ONE,
  TWO,
  THREE,
  FOUR,
  FIVE,
  SIX,
  SEVEN,
  EIGHT,
  NINE,
  ZERO,
  DELETE_ONE,
  DELETE_ALL,
  ADD_COMMATA,
  CLOSE_CALCULATOR
}
