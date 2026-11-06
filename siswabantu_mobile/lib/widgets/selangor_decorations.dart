import 'package:flutter/material.dart';
import 'app_decorations.dart';

// Alias untuk mengekalkan keserasian jika ada fail lama mengimportnya
typedef SelangorVerifiedBadge = StudentVerifiedBadge;
typedef SelangorFlagStripe = ModernAccentStrip;

class SelangorCrescentStarIcon extends StatelessWidget {
  final double size;
  final Color color;

  const SelangorCrescentStarIcon({
    super.key,
    this.size = 20,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.school_rounded, size: size, color: color);
  }
}
