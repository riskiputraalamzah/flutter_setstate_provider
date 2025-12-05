import 'package:flutter/material.dart';

class CalculatorProvider extends ChangeNotifier {
  String _display = '0';
  String _firstOperand = '';
  String _operator = '';
  bool _shouldResetDisplay = false;

  String get display => _display;

  void input(String value) {
    if (_shouldResetDisplay) {
      _display = value;
      _shouldResetDisplay = false;
    } else {
      if (_display == '0') {
        _display = value;
      } else {
        _display += value;
      }
    }
    notifyListeners();
  }

  void operation(String op) {
    if (_firstOperand.isEmpty) {
      _firstOperand = _display;
      _operator = op;
      _shouldResetDisplay = true;
    } else {
      // If we already have an operand and operator, calculate first then set new operator
      if (!_shouldResetDisplay) {
        calculate();
      }
      _operator = op;
      _shouldResetDisplay = true;
    }
    notifyListeners();
  }

  void calculate() {
    if (_firstOperand.isEmpty || _operator.isEmpty) return;

    double num1 = double.parse(_firstOperand);
    double num2 = double.parse(_display);
    double result = 0.0;

    switch (_operator) {
      case '+':
        result = num1 + num2;
        break;
      case '-':
        result = num1 - num2;
        break;
      case '×':
        result = num1 * num2;
        break;
      case '÷':
        if (num2 == 0) {
          _display = 'Error';
          _firstOperand = '';
          _operator = '';
          _shouldResetDisplay = true;
          notifyListeners();
          return;
        }
        result = num1 / num2;
        break;
    }

    // Format result to remove trailing .0 if integer
    if (result % 1 == 0) {
      _display = result.toInt().toString();
    } else {
      _display = result.toString();
    }

    _firstOperand = _display;
    _operator = '';
    // _shouldResetDisplay = true; // Keep result displayed, next input resets it
    notifyListeners();
  }

  void clear() {
    _display = '0';
    _firstOperand = '';
    _operator = '';
    _shouldResetDisplay = false;
    notifyListeners();
  }
}
