import 'package:flutter/material.dart';

class ResponsiveHelper {
  static bool isCompact(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 600;
  }

  static bool isMedium(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= 600 && width < 1024;
  }

  static bool isExpanded(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= 1024 && width < 1440;
  }

  static bool isLarge(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= 1440;
  }

  static int getGridColumns(BuildContext context) {
    if (isLarge(context)) return 6;
    if (isExpanded(context)) return 5;
    if (isMedium(context)) return 3;
    return 2; // Compact
  }

  static double getMaxContentWidth() {
    return 1200.0;
  }
}
