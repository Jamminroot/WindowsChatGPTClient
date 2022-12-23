import 'package:flutter/material.dart';

abstract class Constants {

  static const String appName = "Windows ChatGPT Client";
  static const double titleBarHeight = 32.0;

  static const Color primaryColor = Colors.greenAccent;
  static const backgroundStartColor = Color(0xFFFFF5F0);
  static const backgroundEndColor = Color(0xFAFFEFEF);
  static const sidebarColor = Color(0xFF1b1f24);
  static const darkForegroundColor = Color(0xFF1b1f24);
  static const mainBackgroundColorDark = Color(0xFF343541);
  static const brightForegroundColor = Color(0xFFFFF5F0);

  static final brightForegroundColorSemi = const Color(0xFFFFF5F0).withOpacity(0.5);

  static const cardTitleColor = Color(0xFF2F2A2A);
  static final Color cardTitleColorInactive = cardTitleColor.withOpacity(0.2);

  static Color blendedSidebarColor(Color? color) => Color.alphaBlend(sidebarColor.withOpacity(0.25), color?.withOpacity(0.2) ?? Colors.transparent);
  static const Duration animationDuration = Duration(milliseconds: 120);
}