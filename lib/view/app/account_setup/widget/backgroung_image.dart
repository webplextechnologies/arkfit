import 'package:flutter/material.dart';

class OnboardingBackground extends StatelessWidget {
  final String image;

  const OnboardingBackground({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        image,
        fit: BoxFit.cover,
        color: Colors.white.withOpacity(0.85),
        colorBlendMode: BlendMode.lighten,
      ),
    );
  }
}
