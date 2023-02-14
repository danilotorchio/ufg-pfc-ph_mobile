import 'package:flutter/material.dart';

class UniversityLogo extends StatelessWidget {
  final double scale;

  const UniversityLogo({
    super.key,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'university_logo',
      child: Image.asset(
        'assets/media/ufg.jpg',
        scale: scale,
      ),
    );
  }
}
