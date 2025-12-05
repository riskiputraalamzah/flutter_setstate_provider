import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';
import '../widgets/calculator_button.dart';
import '../widgets/rebuild_indicator.dart';

class CalculatorSetStateScreen extends StatefulWidget {
  const CalculatorSetStateScreen({super.key});

  @override
  State<CalculatorSetStateScreen> createState() =>
      _CalculatorSetStateScreenState();
}

class _CalculatorSetStateScreenState extends State<CalculatorSetStateScreen> {
  String _display = '0';
  String _firstOperand = '';
  String _operator = '';
  bool _shouldResetDisplay = false;
  bool _showInfoMode = false;

  void _toggleInfoMode() {
    setState(() {
      _showInfoMode = !_showInfoMode;
    });
    if (_showInfoMode) {
      _showInfoDialog();
    }
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('SetState Mode', style: TextStyle(color: Colors.white)),
        content: const Text(
          'In SetState, calling setState() triggers the build() method for the ENTIRE widget.\n\n'
          'Notice how the RED border flashes around the WHOLE screen when you press any button.\n'
          'This means everything is being rebuilt, even parts that didn\'t change.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }


  void _input(String value) {
    setState(() {
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
    });
  }

  void _operation(String op) {
    setState(() {
      if (_firstOperand.isEmpty) {
        _firstOperand = _display;
        _operator = op;
        _shouldResetDisplay = true;
      } else {
        if (!_shouldResetDisplay) {
          _calculate();
        }
        _operator = op;
        _shouldResetDisplay = true;
      }
    });
  }

  void _calculate() {
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
          setState(() {
            _display = 'Error';
            _firstOperand = '';
            _operator = '';
            _shouldResetDisplay = true;
          });
          return;
        }
        result = num1 / num2;
        break;
    }

    setState(() {
      if (result % 1 == 0) {
        _display = result.toInt().toString();
      } else {
        _display = result.toString();
      }
      _firstOperand = _display;
      _operator = '';
    });
  }

  void _clear() {
    setState(() {
      _display = '0';
      _firstOperand = '';
      _operator = '';
      _shouldResetDisplay = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RebuildIndicator(
        isEnabled: _showInfoMode,
        label: 'Entire Widget Rebuilds!',
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF2C3E50), Color(0xFF000000)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text(
                            'SetState',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          _showInfoMode ? Icons.visibility : Icons.visibility_off,
                          color: _showInfoMode ? Colors.redAccent : Colors.white,
                        ),
                        onPressed: _toggleInfoMode,
                        tooltip: 'Show Rebuild Info',
                      ),
                    ],
                  ),
                ),
              const Spacer(),
              // Display
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GlassContainer(
                    width: double.infinity,
                    height: 100,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        _display,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Keypad
              GlassContainer(
                width: double.infinity,
                borderRadius: 30,
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CalculatorButton(
                          text: 'C',
                          onPressed: _clear,
                          textColor: Colors.redAccent,
                        ),
                        CalculatorButton(
                            text: '÷',
                            onPressed: () => _operation('÷'),
                            textColor: Colors.cyanAccent),
                        CalculatorButton(
                            text: '×',
                            onPressed: () => _operation('×'),
                            textColor: Colors.cyanAccent),
                        CalculatorButton(
                            text: '-',
                            onPressed: () => _operation('-'),
                            textColor: Colors.cyanAccent),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CalculatorButton(text: '7', onPressed: () => _input('7')),
                        CalculatorButton(text: '8', onPressed: () => _input('8')),
                        CalculatorButton(text: '9', onPressed: () => _input('9')),
                        CalculatorButton(
                            text: '+',
                            onPressed: () => _operation('+'),
                            textColor: Colors.cyanAccent),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CalculatorButton(text: '4', onPressed: () => _input('4')),
                        CalculatorButton(text: '5', onPressed: () => _input('5')),
                        CalculatorButton(text: '6', onPressed: () => _input('6')),
                        CalculatorButton(
                          text: '=',
                          onPressed: _calculate,
                          backgroundColor: Colors.cyanAccent.withOpacity(0.3),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CalculatorButton(text: '1', onPressed: () => _input('1')),
                        CalculatorButton(text: '2', onPressed: () => _input('2')),
                        CalculatorButton(text: '3', onPressed: () => _input('3')),
                        CalculatorButton(text: '0', onPressed: () => _input('0')),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
