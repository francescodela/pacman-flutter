import 'dart:math';
import 'package:flutter/material.dart'; // Canvas, Paint, Rect, Offset, etc.

import 'constants.dart'; // colores y tamaños
import 'game_map.dart'; // el mapa (GameMap.layout)

class GamePainter extends CustomPainter {
  final double pacmanX; // posición X de Pac-Man (en celdas)
  final double pacmanY; // posición Y de Pac-Man
  final String direction; // 'right', 'left', 'up', 'down'
  final Color pacmanColor; // color actual de Pac-Man

  GamePainter({
    required this.pacmanX,
    required this.pacmanY,
    required this.direction,
    required this.pacmanColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // A. Tamaño de cada celda
    final cellWidth = size.width / kMapWidth;
    final cellHeight = size.height / kMapHeight;

    // B. Fondo negro
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = Colors.black,
    );

    // C. Dibujar el mapa (paredes, puntos, power pellets)
    for (int y = 0; y < kMapHeight; y++) {
      for (int x = 0; x < kMapWidth; x++) {
        final rect =
            Rect.fromLTWH(x * cellWidth, y * cellHeight, cellWidth, cellHeight);

        switch (GameMap.layout[y][x]) {
          case 1: // Pared: azul + borde claro para efecto 3D
            canvas.drawRect(rect.deflate(1), Paint()..color = kWallColor);
            canvas.drawRect(
              rect.deflate(1),
              Paint()
                ..color = kWallBorderColor
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2,
            );
            break;
          case 2: // Punto normal: círculo pequeño amarillo
            canvas.drawCircle(
                rect.center, cellWidth * 0.1, Paint()..color = kDotColor);
            break;
          case 3: // Punto grande: círculo naranja + glow
            canvas.drawCircle(
              rect.center,
              cellWidth * 0.3,
              Paint()
                ..color = kPowerDotColor.withOpacity(0.5)
                ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
            );
            canvas.drawCircle(
                rect.center, cellWidth * 0.2, Paint()..color = kPowerDotColor);
            break;
        }
      }
    }

    // D. Pac-Man con animación de boca
    final pacRect = Rect.fromLTWH(
        pacmanX * cellWidth, pacmanY * cellHeight, cellWidth, cellHeight);
    final pacPaint = Paint()..color = pacmanColor;

    double time = DateTime.now().millisecondsSinceEpoch / 200.0;
    double mouthAngle = 0.3 + sin(time) * 0.2; // abre y cierra con el tiempo

    double baseAngle;
    switch (direction) {
      case 'left':
        baseAngle = pi;
        break;
      case 'up':
        baseAngle = 3 * pi / 2;
        break;
      case 'down':
        baseAngle = pi / 2;
        break;
      case 'right':
      default:
        baseAngle = 0;
    }
    final startAngle = baseAngle + mouthAngle;
    final sweepAngle = 2 * pi - 2 * mouthAngle;

    canvas.drawArc(pacRect, startAngle, sweepAngle, true, pacPaint);

    // E. Ojo (mira hacia la dirección)
    final eyePaint = Paint()..color = kEyeColor;
    final c = pacRect.center;
    Offset eyePosition;
    switch (direction) {
      case 'left':
        eyePosition = Offset(c.dx - cellWidth * 0.1, c.dy - cellHeight * 0.25);
        break;
      case 'up':
        eyePosition = Offset(c.dx + cellWidth * 0.2, c.dy - cellHeight * 0.1);
        break;
      case 'down':
        eyePosition = Offset(c.dx + cellWidth * 0.2, c.dy + cellHeight * 0.1);
        break;
      case 'right':
      default:
        eyePosition = Offset(c.dx + cellWidth * 0.1, c.dy - cellHeight * 0.25);
    }
    canvas.drawCircle(eyePosition, cellWidth * 0.06, eyePaint);
  }

  // 4. shouldRepaint (optimización): solo repinta si cambió posición o dirección
  @override
  bool shouldRepaint(covariant GamePainter oldDelegate) {
    return oldDelegate.pacmanX != pacmanX ||
        oldDelegate.pacmanY != pacmanY ||
        oldDelegate.direction != direction ||
        oldDelegate.pacmanColor != pacmanColor;
  }
}
