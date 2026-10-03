import 'dart:math';
import 'package:flutter/material.dart';

class WeatherBackgroundWidget extends StatefulWidget {
  final int weatherCode;
  final bool isDay;
  final List<Color> gradientColors;

  const WeatherBackgroundWidget({
    Key? key,
    required this.weatherCode,
    required this.isDay,
    required this.gradientColors,
  }) : super(key: key);

  @override
  State<WeatherBackgroundWidget> createState() => _WeatherBackgroundWidgetState();
}

class _WeatherBackgroundWidgetState extends State<WeatherBackgroundWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: WeatherBackgroundPainter(
            gradientColors: widget.gradientColors,
            weatherCode: widget.weatherCode,
            isDay: widget.isDay,
            animationValue: _controller.value,
          ),
        );
      },
    );
  }
}

class WeatherBackgroundPainter extends CustomPainter {
  final List<Color> gradientColors;
  final int weatherCode;
  final bool isDay;
  final double animationValue;
  final Random _random = Random(42);

  WeatherBackgroundPainter({
    required this.gradientColors,
    required this.weatherCode,
    required this.isDay,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: gradientColors,
      ).createShader(rect);

    canvas.drawRect(rect, paint);

    if (!isDay) {
      _drawStars(canvas, size);
    }

    if (weatherCode >= 51 && weatherCode <= 67 || weatherCode >= 80 && weatherCode <= 82) {
      _drawRain(canvas, size);
    } else if (weatherCode >= 1 && weatherCode <= 3 || weatherCode >= 45 && weatherCode <= 48) {
      _drawClouds(canvas, size);
    } else if (weatherCode >= 95 && weatherCode <= 99) {
      _drawStorm(canvas, size);
    } else if (weatherCode >= 71 && weatherCode <= 77 || weatherCode >= 85 && weatherCode <= 86) {
      _drawSnow(canvas, size);
    }
  }

  void _drawStars(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (int i = 0; i < 50; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * (size.height / 2);
      final radius = _random.nextDouble() * 1.5;
      final alpha = (sin((animationValue * 2 * pi) + i) * 127 + 128).toInt();
      paint.color = Colors.white.withAlpha(alpha);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  void _drawRain(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1.5;
    for (int i = 0; i < 60; i++) {
      final x = _random.nextDouble() * size.width;
      double y = (_random.nextDouble() * size.height) + (animationValue * size.height);
      y = y % size.height;
      canvas.drawLine(Offset(x, y), Offset(x, y + 15), paint);
    }
  }

  void _drawClouds(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    
    for (int i = 0; i < 3; i++) {
      double x = (_random.nextDouble() * size.width) + (animationValue * 100);
      x = x % (size.width + 200) - 100;
      final y = _random.nextDouble() * (size.height / 3);
      canvas.drawOval(Rect.fromCenter(center: Offset(x, y), width: 150, height: 60), paint);
    }
  }

  void _drawStorm(Canvas canvas, Size size) {
    if (animationValue > 0.85 && animationValue < 0.9) {
      final paint = Paint()..color = Colors.white.withOpacity(0.3);
      canvas.drawRect(Offset.zero & size, paint);
    }
    _drawRain(canvas, size);
  }

  void _drawSnow(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.7);
    for (int i = 0; i < 50; i++) {
      final x = _random.nextDouble() * size.width;
      double y = (_random.nextDouble() * size.height) + (animationValue * size.height * 0.5);
      y = y % size.height;
      final radius = _random.nextDouble() * 3 + 1;
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WeatherBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
           oldDelegate.weatherCode != weatherCode ||
           oldDelegate.isDay != isDay ||
           oldDelegate.gradientColors != gradientColors;
  }
}
