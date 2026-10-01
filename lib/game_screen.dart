import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';
import 'game_map.dart';
import 'game_painter.dart';
import 'lose_dialog.dart';
import 'score_display.dart';
import 'win_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  double pacX = 1, pacY = 1;
  String direction = 'right';
  String nextDirection = 'right';
  int score = 0;
  int _round = 0; // fuerza repintado al reiniciar
  bool _gameOver = false;
  Timer? _timer;
  final FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    GameMap.resetMap();
    pacX = 1;
    pacY = 1;
    direction = 'right';
    nextDirection = 'right';
    score = 0;
    _gameOver = false;
    GameMap.layout[1][1] = 0; // casilla inicial vacía
    _timer?.cancel();
    _timer = Timer.periodic(
        Duration(milliseconds: kGameSpeedMs.toInt()), (_) => _tick());
  }

  void _restart() {
    setState(() {
      _round++;
      _start();
    });
    _focus.requestFocus();
  }

  int _dx(String d) => d == 'right' ? 1 : (d == 'left' ? -1 : 0);
  int _dy(String d) => d == 'down' ? 1 : (d == 'up' ? -1 : 0);
  String _opposite(String d) =>
      {'right': 'left', 'left': 'right', 'up': 'down', 'down': 'up'}[d]!;
  bool _blocked(int cx, int cy, String d) =>
      GameMap.isWall(cx + _dx(d), cy + _dy(d));

  void _tick() {
    if (!mounted) return;
    setState(() {
      final atCenter = pacX % 1 == 0 && pacY % 1 == 0;
      if (atCenter) {
        final cx = pacX.round(), cy = pacY.round();
        if (!_blocked(cx, cy, nextDirection)) direction = nextDirection;
        if (_blocked(cx, cy, direction)) {
          _lose(); // choca con pared: se detiene y pierde
          return;
        }
      } else if (nextDirection == _opposite(direction)) {
        direction = nextDirection; // permite dar media vuelta
      }

      pacX += _dx(direction) * 0.5;
      pacY += _dy(direction) * 0.5;

      if (pacX % 1 == 0 && pacY % 1 == 0) _eat(pacX.round(), pacY.round());
    });
  }

  void _lose() {
    if (_gameOver) return;
    _gameOver = true;
    _timer?.cancel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) showLoseDialog(context, score, _restart);
    });
  }

  void _eat(int x, int y) {
    final v = GameMap.layout[y][x];
    if (v == 2) score += kNormalDotPoints;
    if (v == 3) score += kPowerDotPoints;
    GameMap.layout[y][x] = 0;

    final left = GameMap.layout.any((row) => row.any((c) => c == 2 || c == 3));
    if (!left) {
      _timer?.cancel();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showWinDialog(context, score, _restart);
      });
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final k = event.logicalKey;
    if (k == LogicalKeyboardKey.arrowUp) {
      nextDirection = 'up';
    } else if (k == LogicalKeyboardKey.arrowDown) {
      nextDirection = 'down';
    } else if (k == LogicalKeyboardKey.arrowLeft) {
      nextDirection = 'left';
    } else if (k == LogicalKeyboardKey.arrowRight) {
      nextDirection = 'right';
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Focus(
          autofocus: true,
          focusNode: _focus,
          onKeyEvent: _onKey,
          child: Column(
            children: [
              ScoreDisplay(score: score, onReset: _restart),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: kMapWidth / kMapHeight,
                    child: GestureDetector(
                      onPanUpdate: (d) {
                        if (d.delta.dx.abs() > d.delta.dy.abs()) {
                          nextDirection = d.delta.dx > 0 ? 'right' : 'left';
                        } else {
                          nextDirection = d.delta.dy > 0 ? 'down' : 'up';
                        }
                      },
                      child: CustomPaint(
                        key: ValueKey(_round),
                        painter: GamePainter(
                            pacmanX: pacX,
                            pacmanY: pacY,
                            direction: direction,
                            pacmanColor: pacmanColorForScore(score)),
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text('Usa las flechas del teclado (o desliza el dedo)',
                    style: TextStyle(color: Colors.white54)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
