import 'package:flutter/material.dart';

Future<void> showWinDialog(
    BuildContext context, int score, VoidCallback onRestart) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: const Text('¡Ganaste! 🎉'),
      content: Text('Te comiste todos los puntos.\nPuntaje final: $score'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            onRestart();
          },
          child: const Text('Jugar de nuevo'),
        ),
      ],
    ),
  );
}
