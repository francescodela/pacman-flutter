#  Pac-Man Flutter

Juego estilo Pac-Man hecho con **Flutter** y **CustomPainter**.

## Características
- Mapa de 15x9 celdas con paredes, puntos (10 pts) y power pellets (50 pts)
- Controles con las flechas del teclado o deslizando el dedo
- Pac-Man cambia de color cada 100 puntos
- Pierdes si chocas con una pared; ganas al comer todos los puntos
- Botón de reinicio y diálogos de victoria/derrota
- Multiplataforma: Web, Android, iOS, Windows, macOS y Linux

## Cómo ejecutarlo
    git clone https://github.com/TU_USUARIO/pacman-flutter.git
    cd pacman-flutter
    flutter pub get
    flutter run -d chrome

## Estructura
- `lib/main.dart`: punto de entrada
- `lib/game_screen.dart`: lógica del juego y controles
- `lib/game_painter.dart`: dibujo del mapa y Pac-Man
- `lib/game_map.dart`: diseño del mapa y colisiones
- `lib/constants.dart`: colores, velocidad y puntajes
