import 'dart:math';

import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final int index;

  Tile({Key? key, required this.index}) : super(key: key);

  // Generate a random color
  Color _getRandomColor() {
    final random = Random(
      index,
    ); // Use index as seed for consistent colors per tile
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getRandomColor(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          '$index',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
