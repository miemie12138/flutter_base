import 'dart:math';
import 'package:flutter/material.dart';

class FlowerLoadingIndicator extends StatefulWidget {
  const FlowerLoadingIndicator({super.key});

  @override
  State<FlowerLoadingIndicator> createState() => _FlowerLoadingIndicatorState();
}

class _FlowerLoadingIndicatorState extends State<FlowerLoadingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000), // 控制动画的总时长
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(48, 48),
            painter: FlowerPainter(progress: _controller.value),
          );
        },
      ),
    );
  }
}

class FlowerPainter extends CustomPainter {
  final double progress;

  FlowerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    var center = Offset(size.width / 2, size.height / 2);
    var radius = min(size.width / 2, size.height / 2);
    var circleRadius = radius / 4;
    var numberOfCircles = 8;
    var activeCircles = (numberOfCircles * progress).round();

    for (int i = 0; i < numberOfCircles; i++) {
      var angle = 2 * pi * i / numberOfCircles - pi / 2;
      var circleCenter =
          Offset(center.dx + (radius - circleRadius) * cos(angle), center.dy + (radius - circleRadius) * sin(angle));
      Color color = const Color(0xFFE60012).withOpacity((1.0 / numberOfCircles) * (i + 1));
      var paint = Paint()
        ..color = i < activeCircles ? color : Colors.transparent
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
          circleCenter, circleRadius / 3.0 + ((circleRadius - circleRadius / 3.0) / numberOfCircles) * (i + 1), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true; // 总是重绘以响应动画
}
