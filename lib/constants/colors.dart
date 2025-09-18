import 'package:flutter/material.dart';
import 'package:canary_oklch/canary_oklch.dart';

class AppColors {
  // Primary colors using OKLCH
  static final primary = OklchColor(0.6, 0.1234, 151.09).toColor();
  static final primaryLight = OklchColor(0.7, 0.1234, 151.09).toColor();
  static final primaryLightest = OklchColor(0.8, 0.1234, 151.09).toColor();
  static final primaryDark = OklchColor(0.5, 0.1234, 151.09).toColor();
  static final primaryDarkest = OklchColor(0.4, 0.1234, 151.09).toColor();

  // Secondary colors
  static final secondary = OklchColor(0.6, 0.1234, 232.24).toColor();
  static final secondaryLight = OklchColor(0.7, 0.1234, 232.24).toColor();
  static final secondaryLightest = OklchColor(0.8, 0.1234, 232.24).toColor();
  static final secondaryDark = OklchColor(0.5, 0.1234, 232.24).toColor();
  static final secondaryDarkest = OklchColor(0.4, 0.1234, 232.24).toColor();

  // Emotion colors for mood tracking
  static final happy = OklchColor(0.85, 0.07, 10).toColor(); // Pink
  static final excited = OklchColor(0.85, 0.07, 60).toColor(); // Orange
  static final calm = OklchColor(0.85, 0.07, 194).toColor(); // Light blue
  static final sad = OklchColor(0.85, 0.07, 250).toColor(); // Blue
  static final angry = OklchColor(0.85, 0.07, 32).toColor(); // Red
  static final anxious = OklchColor(0.85, 0.07, 298).toColor(); // Purple

  // Neutral colors
  static final neutral100 = OklchColor(0.95, 0.008, 267).toColor();
  static final neutral200 = OklchColor(0.9, 0.008, 267).toColor();
  static final neutral300 = OklchColor(0.8, 0.008, 267).toColor();
  static final neutral400 = OklchColor(0.7, 0.008, 267).toColor();
  static final neutral500 = OklchColor(0.6, 0.008, 267).toColor();
  static final neutral600 = OklchColor(0.5, 0.008, 267).toColor();
  static final neutral700 = OklchColor(0.4, 0.008, 267).toColor();
  static final neutral800 = OklchColor(0.3, 0.008, 267).toColor();
  static final neutral900 = OklchColor(0.1, 0.008, 267).toColor();

  // Text colors
  static final textPrimaryLight = OklchColor(0.15, 0.02, 280).toColor();
  static final textPrimaryDark = OklchColor(0.95, 0.01, 280).toColor();
  static final textSecondaryLight = OklchColor(0.45, 0.03, 280).toColor();
  static final textSecondaryDark = OklchColor(0.75, 0.02, 280).toColor();

  // Success, Warning, Error colors
  static final success = OklchColor(0.7, 0.18, 140).toColor();
  static final warning = OklchColor(0.8, 0.18, 80).toColor();
  static final error = OklchColor(0.7, 0.18, 35).toColor();

  // Helper method to create color variations
  static Color createVariation({
    required Color baseColor,
    double lightnessOffset = 0.0,
    double chromaOffset = 0.0,
    double hueOffset = 0.0,
  }) {
    final oklch = OklchColor.fromColor(baseColor);
    return OklchColor(
      (oklch.l + lightnessOffset).clamp(0.0, 1.0),
      (oklch.c + chromaOffset).clamp(0.0, 0.4),
      (oklch.h + hueOffset) % 360,
    ).toColor();
  }
}
