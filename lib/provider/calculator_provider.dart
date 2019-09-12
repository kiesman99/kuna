import 'package:flutter/material.dart';
import 'package:kuna/provider/page_provider.dart';
import 'package:kuna/provider/shared_pref_provider.dart';
import 'package:kuna/widgets/calculator_pad.dart';
import 'package:provider/provider.dart';

/// This class will provide the functionality of the Calculator
/// It will notify all it observers when something changed
class CalculatorProvider with ChangeNotifier {
  // needed Provider
  SettingsProvider sharedPrefProvider;
  PageProvider pageProvider;

  double get _course => sharedPrefProvider.course;

  CalculatorProvider(
      {@required this.sharedPrefProvider, @required this.pageProvider});

  String _calcPadNumber = "";

  String get calcPadNumber => _calcPadNumber;

  String get calculatedValue => _calcPadNumber != ""
      ? (double.parse(_calcPadNumber) / _course).toString()
      : "";

  void calcButtonPress(CalculatorAction action) {
    switch (action) {
      case CalculatorAction.ONE:
        _calcPadNumber += "1";
        break;
      case CalculatorAction.TWO:
        _calcPadNumber += "2";
        break;
      case CalculatorAction.THREE:
        _calcPadNumber += "3";
        break;
      case CalculatorAction.FOUR:
        _calcPadNumber += "4";
        break;
      case CalculatorAction.FIVE:
        _calcPadNumber += "5";
        break;
      case CalculatorAction.SIX:
        _calcPadNumber += "6";
        break;
      case CalculatorAction.SEVEN:
        _calcPadNumber += "7";
        break;
      case CalculatorAction.EIGHT:
        _calcPadNumber += "8";
        break;
      case CalculatorAction.NINE:
        _calcPadNumber += "9";
        break;
      case CalculatorAction.ZERO:
        _calcPadNumber += "0";
        break;
      case CalculatorAction.DELETE_ONE:
        if (_calcPadNumber.length != 0) {
          _calcPadNumber =
              _calcPadNumber.substring(0, _calcPadNumber.length - 1);
        }
        break;
      case CalculatorAction.DELETE_ALL:
        _calcPadNumber = "";
        break;
      case CalculatorAction.ADD_COMMATA:
        // Multiple commata will lead to errors
        if (_calcPadNumber.length != 0 && !_calcPadNumber.contains(".")) {
          _calcPadNumber += ".";
        }
        break;
      case CalculatorAction.CLOSE_CALCULATOR:
        pageProvider.switchView();
        break;
    }

    notifyListeners();
  }
}
