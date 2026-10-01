import 'package:flutter/material.dart';

class ScoreDisplay extends StatelessWidget {
  final int score;
  final VoidCallback onReset;

  const ScoreDisplay({super.key, required this.score, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Puntaje: $score',
            style: const TextStyle(
                color: Colors.yellow, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          ElevatedButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh),
            label: const Text('Reiniciar'),
          ),
        ],
      ),
    );
  }
}
