import 'constants.dart';

class GameMap {
  // 1 = pared, 2 = punto normal, 3 = power pellet, 0 = vacío
  static const List<List<int>> originalLayout = [
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], // Fila 0: borde superior
    [1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1], // Fila 1: pasillo con puntos
    [1, 2, 1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2, 1],
    [1, 3, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1, 3, 1], // Fila 3: power pellets
    [1, 2, 1, 1, 2, 1, 1, 1, 1, 1, 2, 1, 1, 2, 1],
    [1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1],
    [1, 2, 1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 1, 2, 1],
    [1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], // Fila 8: borde inferior
  ];

  // Variable que guarda el mapa modificable
  static late List<List<int>> layout;

  // Función para reiniciar el mapa
  static void resetMap() {
    layout = originalLayout.map((row) => List<int>.from(row)).toList();
  }

  // Función para detectar paredes (colisiones)
  static bool isWall(int x, int y) {
    if (x < 0 || x >= kMapWidth || y < 0 || y >= kMapHeight) return true;
    return layout[y][x] == 1;
  }
}
