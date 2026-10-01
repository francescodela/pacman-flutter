import 'package:flutter/material.dart';

Future<void> showLoseDialog(
    BuildContext context, int score, VoidCallback onRestart) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: const Text('¡Perdiste! 💥'),
      content: Text('Pac-Man chocó contra una pared.\nPuntaje final: $score'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            onRestart();
          },
          child: const Text('Intentar de nuevo'),
        ),
      ],
    ),
  );
}
