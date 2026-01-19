import 'package:flutter/material.dart';

class AppColors {
  static const Color bocGold = Color(0xFFF4C430);
  static const Color bocDarkGold = Color(0xFFD4A017);
  static const Color bocBlack = Color(0xFF1A1A1A);
  static const Color bocDarkBg = Color(0xFF2D2D2D);
  static const Color bocTextLight = Color(0xFFFFFFFF);
  static const Color bocTextDark = Color(0xFF000000);
  static const Color bocError = Color(0xFFFF4444);
  static const Color bocSuccess = Color(0xFF00C853);

  static const LinearGradient goldGradient = LinearGradient(
    colors: [bocGold, bocDarkGold],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
