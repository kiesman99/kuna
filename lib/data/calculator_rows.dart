import 'package:flutter/material.dart';
import 'package:kuna/widgets/calculator_pad.dart';

class CalculatorRows {
  static final TextStyle style =
      const TextStyle(fontSize: 26.0, color: Colors.white);

  static final List<List<CalculatorTile>> calculatorRows = [
    [
      CalculatorTile(
          child: Text("1", style: style), onTap: CalculatorAction.ONE),
      CalculatorTile(
          child: Text("2", style: style), onTap: CalculatorAction.TWO),
      CalculatorTile(
          child: Text("3", style: style), onTap: CalculatorAction.THREE),
      CalculatorTile(
          child: Icon(Icons.backspace, color: Colors.white),
          onTap: CalculatorAction.DELETE_ONE,
          onLongPress: CalculatorAction.DELETE_ALL),
    ],
    [
      CalculatorTile(
          child: Text("4", style: style), onTap: CalculatorAction.FOUR),
      CalculatorTile(
          child: Text("5", style: style), onTap: CalculatorAction.FIVE),
      CalculatorTile(
          child: Text("6", style: style), onTap: CalculatorAction.SIX),
      CalculatorTile(
          child: Text(",", style: style), onTap: CalculatorAction.ADD_COMMATA)
    ],
    [
      CalculatorTile(
          child: Text("7", style: style), onTap: CalculatorAction.SEVEN),
      CalculatorTile(
          child: Text("8", style: style), onTap: CalculatorAction.EIGHT),
      CalculatorTile(
          child: Text("9", style: style), onTap: CalculatorAction.NINE),
      CalculatorTile.empty()
    ],
    [
      CalculatorTile.empty(),
      CalculatorTile(
          child: Text("0", style: style), onTap: CalculatorAction.ZERO),
      CalculatorTile.empty(),
      CalculatorTile(
          child: Icon(
            Icons.grid_on,
            color: Colors.white,
          ),
          onTap: CalculatorAction.CLOSE_CALCULATOR),
    ],
  ];
}
