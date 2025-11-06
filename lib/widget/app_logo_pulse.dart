// lib/widgets/app_logo_pulse.dart
import 'package:flutter/material.dart';

class AppLogoPulse extends StatefulWidget {
  final String asset;
  final double size;
  final Duration duration;
  const AppLogoPulse({
    super.key,
    required this.asset,
    this.size = 72,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<AppLogoPulse> createState() => _AppLogoPulseState();
}

class _AppLogoPulseState extends State<AppLogoPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.duration)..repeat();
  late final Animation<double> _scale = Tween(begin: 0.94, end: 1.06)
      .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  late final Animation<double> _fade = Tween(begin: 0.85, end: 1.0)
      .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 1),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              widget.asset,
              width: widget.size,
              height: widget.size,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
