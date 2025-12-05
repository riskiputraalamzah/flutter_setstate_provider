import 'package:flutter/material.dart';
import 'glass_container.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? textColor;
  final Color? backgroundColor;
  final bool isLarge;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.backgroundColor,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        child: GlassContainer(
          width: isLarge ? 160 : 70,
          height: 70,
          borderRadius: 20,
          padding: EdgeInsets.zero,
          color: backgroundColor ?? Colors.white,
          opacity: backgroundColor != null ? 0.3 : 0.1,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
