import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Theme {

  static const Color loginGradientStart = const Color(0xFFCFF3FC);
  static const Color loginGradientEnd = const Color(0xFF33D1FF);

  static const LinearGradient primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}