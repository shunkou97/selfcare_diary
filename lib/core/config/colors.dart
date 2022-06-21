import 'package:flutter/material.dart';

//Change colors as Design

class AppColors {
  AppColors._(); // this basically makes it so you can instantiate this class

  static const Color primary = Color(0xFF5768FF);

  static const Map<int, Color> blue = <int, Color>{
    500: Color(0xFF5768FF),
  };

  static const Map<int, Color> ink = <int, Color>{
    0: Color(0xFFFFFFFF),
    100: Color(0xFFF2F3F4),
    200: Color(0xFFE1E6EB),
    300: Color(0xFFB4B2BC),
    400: Color(0xFF7B8090),
    500: Color(0xFF1F2738),
  };

  static const Map<int, Color> red = <int, Color>{
    500: Color(0xFFE41338),
  };

  static const Map<int, Color> green = <int, Color>{
    500: Color(0xFF1CBB78),
  };

  static const Map<int, Color> primaryColors = <int, Color>{
    100: Color(0xFFF8F8FF),
    200: Color(0xFFE2E5FF),
    300: Color(0xFFAEB7FF),
    400: Color(0xFF7987FF),
    500: Color(0xFF5768FF),
  };

  static const Color backgroundLight = Color(0xFFF8F8FF);
  static const Color backgroundDark = Color(0xFFF2F3F4);
  static const Color iconColor = Color(0xFF555B7C);
}
