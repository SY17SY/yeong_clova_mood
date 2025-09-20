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
  static final happy = OklchColor(0.89, 0.07, 1).toColor(); // Pink
  static final excited = OklchColor(0.85, 0.07, 60).toColor(); // Orange
  static final calm = OklchColor(0.85, 0.07, 194).toColor(); // Light blue
  static final sad = OklchColor(0.85, 0.07, 250).toColor(); // Blue
  static final angry = OklchColor(0.83, 0.07, 30).toColor(); // Red
  static final anxious = OklchColor(0.85, 0.07, 298).toColor(); // Purple
  static final lucky = OklchColor(0.85, 0.07, 151.09).toColor(); // green

  // Emotion colors for mood tracking
  static final happyDark = OklchColor(0.65, 0.12, 1).toColor(); // Pink
  static final excitedDark = OklchColor(0.65, 0.12, 60).toColor(); // Orange
  static final calmDark = OklchColor(0.65, 0.12, 194).toColor(); // Light blue
  static final sadDark = OklchColor(0.65, 0.12, 250).toColor(); // Blue
  static final angryDark = OklchColor(0.65, 0.12, 30).toColor(); // Red
  static final anxiousDark = OklchColor(0.65, 0.12, 298).toColor(); // Purple
  static final luckyDark = OklchColor(0.65, 0.12, 151.09).toColor(); // green

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
