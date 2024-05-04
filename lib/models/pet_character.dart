import 'package:flutter/material.dart';

class Character {
  final String name;
  final double scale;
  Offset offset;

  Character({
    required this.name,
    this.scale = 1,
    this.offset = const Offset(0, 0),
  });

  get asset {
    return 'assets/animations/$name.flr';
  }
}
