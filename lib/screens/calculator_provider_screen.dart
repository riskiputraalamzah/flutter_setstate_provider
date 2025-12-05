import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calculator_provider.dart';
import '../widgets/glass_container.dart';
import '../widgets/calculator_button.dart';
import '../widgets/rebuild_indicator.dart';

class CalculatorProviderScreen extends StatefulWidget {
  const CalculatorProviderScreen({super.key});

  @override
  State<CalculatorProviderScreen> createState() => _CalculatorProviderScreenState();
}

class _CalculatorProviderScreenState extends State<CalculatorProviderScreen> {
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
        title: const Text('Provider Mode', style: TextStyle(color: Colors.white)),
        content: const Text(
          'In Provider, logic is separated from UI.\n\n'
          'Notice how the RED border flashes ONLY around the Display when you press buttons.\n'
          'The buttons and background DO NOT flash because they are not rebuilding. This is much more efficient!',
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4B0082), Color(0xFF000000)],
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
                          'Provider',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        _showInfoMode ? Icons.visibility : Icons.visibility_off,
                        color: _showInfoMode ? Colors.greenAccent : Colors.white,
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
                      child: Consumer<CalculatorProvider>(
                        builder: (context, provider, child) {
                          return RebuildIndicator(
                            isEnabled: _showInfoMode,
                            label: 'Only This Rebuilds!',
                            child: Text(
                              provider.display,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Keypad
              RebuildIndicator(
                isEnabled: _showInfoMode,
                label: 'Static (No Rebuild)',
                child: Consumer<CalculatorProvider>(
                  builder: (context, provider, child) {
                    return GlassContainer(
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
                                onPressed: provider.clear,
                                textColor: Colors.redAccent,
                              ),
                              CalculatorButton(
                                  text: '÷',
                                  onPressed: () => provider.operation('÷'),
                                  textColor: Colors.purpleAccent),
                              CalculatorButton(
                                  text: '×',
                                  onPressed: () => provider.operation('×'),
                                  textColor: Colors.purpleAccent),
                              CalculatorButton(
                                  text: '-',
                                  onPressed: () => provider.operation('-'),
                                  textColor: Colors.purpleAccent),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CalculatorButton(
                                  text: '7',
                                  onPressed: () => provider.input('7')),
                              CalculatorButton(
                                  text: '8',
                                  onPressed: () => provider.input('8')),
                              CalculatorButton(
                                  text: '9',
                                  onPressed: () => provider.input('9')),
                              CalculatorButton(
                                  text: '+',
                                  onPressed: () => provider.operation('+'),
                                  textColor: Colors.purpleAccent),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CalculatorButton(
                                  text: '4',
                                  onPressed: () => provider.input('4')),
                              CalculatorButton(
                                  text: '5',
                                  onPressed: () => provider.input('5')),
                              CalculatorButton(
                                  text: '6',
                                  onPressed: () => provider.input('6')),
                              CalculatorButton(
                                text: '=',
                                onPressed: provider.calculate,
                                backgroundColor:
                                    Colors.purpleAccent.withOpacity(0.3),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CalculatorButton(
                                  text: '1',
                                  onPressed: () => provider.input('1')),
                              CalculatorButton(
                                  text: '2',
                                  onPressed: () => provider.input('2')),
                              CalculatorButton(
                                  text: '3',
                                  onPressed: () => provider.input('3')),
                              CalculatorButton(
                                  text: '0',
                                  onPressed: () => provider.input('0')),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
