import 'package:flutter/material.dart';

// Constantes del mapa (dimensiones del tablero)
const int kMapWidth = 15; // Ancho del mapa en celdas (15 columnas)
const int kMapHeight = 9; // Alto del mapa en celdas (9 filas)

// Colores (paleta visual del juego)
const Color kWallColor = Color(0xFF1565C0); // Azul oscuro para paredes
const Color kWallBorderColor = Color(0xFF42A5F5); // Azul claro para el borde (efecto 3D)
const Color kDotColor = Colors.yellow; // Puntos normales
const Color kPowerDotColor = Colors.orange; // Puntos grandes (power pellets)
const Color kEyeColor = Colors.black; // Ojo de Pac-Man

// Colores de Pac-Man: cambia cada 100 puntos
const int kPointsPerColor = 100;
const List<Color> kPacmanColors = [
  Colors.yellow, // 0 - 99
  Colors.green, // 100 - 199
  Colors.blue, // 200 - 299
  Colors.red, // 300 - 399
  Colors.purple, // 400 - 499
  Colors.orange, // 500 - 599
  Colors.pink, // 600 - 699
  Colors.cyan, // 700 - 799
];

// Devuelve el color de Pac-Man según el puntaje (se repite el ciclo al final)
Color pacmanColorForScore(int score) {
  final index = (score ~/ kPointsPerColor) % kPacmanColors.length;
  return kPacmanColors[index];
}

// Configuración del juego (velocidad y puntajes)
const double kGameSpeedMs = 200.0; // Cada 200 ms Pac-Man avanza 0.5 celdas
const int kNormalDotPoints = 10; // Puntos por punto normal
const int kPowerDotPoints = 50; // Puntos por power pellet
