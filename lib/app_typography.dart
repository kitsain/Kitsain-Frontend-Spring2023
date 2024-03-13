import 'package:flutter/material.dart';
import 'package:kitsain_frontend_spring2023/app_colors.dart';

class AppTypography {
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontWeight: FontWeight.w900,
    fontSize: 40,
    height: 1.33,
  );
  static const TextStyle heading2 = TextStyle(
    fontFamily: 'PlayfairDisplay',
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.34,
    letterSpacing: 0,
  );
  static const TextStyle heading3 = TextStyle(
    fontFamily: 'GillSans',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.21,
    letterSpacing: 0,
  );
  static const TextStyle heading4 = TextStyle(
    fontFamily: 'GillSans',
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.20,
    letterSpacing: 0,
  );
  static const TextStyle heading5 = TextStyle(
    fontFamily: 'GillSans',
    fontSize: 17,
    fontWeight: FontWeight.w500,
    height: 1.20,
    letterSpacing: 0,
  );
  static const TextStyle category = TextStyle(
    fontFamily: 'GillSans',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.19,
    letterSpacing: 0,
  );
  static const TextStyle paragraph = TextStyle(
    fontFamily: 'Vollkorn',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.375,
    letterSpacing: 0,
  );
  static const TextStyle smallTitle = TextStyle(
    fontFamily: 'GillSans',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.17,
    letterSpacing: 0,
  );
  static TextStyle whiteHeading2 = heading2.copyWith(
    color: AppColors.main2,
  );
}
