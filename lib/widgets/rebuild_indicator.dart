import 'package:flutter/material.dart';

class RebuildIndicator extends StatefulWidget {
  final Widget child;
  final String label;
  final bool isEnabled;

  const RebuildIndicator({
    super.key,
    required this.child,
    required this.label,
    this.isEnabled = true,
  });

  @override
  State<RebuildIndicator> createState() => _RebuildIndicatorState();
}

class _RebuildIndicatorState extends State<RebuildIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.red.withOpacity(0.3),
    ).animate(_controller);
    
    if (widget.isEnabled) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void didUpdateWidget(RebuildIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEnabled) {
      _controller.reset();
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled) return widget.child;

    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: _colorAnimation.value ?? Colors.transparent,
              width: 4,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              widget.child,
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: _colorAnimation.value ?? Colors.transparent,
                  child: Text(
                    widget.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
