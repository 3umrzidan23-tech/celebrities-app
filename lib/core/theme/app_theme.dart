import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primaryBlue,
        scaffoldBackgroundColor: AppColors.background,
        cardColor: AppColors.cardColor,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppTextStyles.title,
          iconTheme: const IconThemeData(color: AppColors.textWhite),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.navBarBackground,
          selectedItemColor: AppColors.lightBlue,
          unselectedItemColor: AppColors.textGrey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 10,
        ),
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryBlue,
          surface: AppColors.cardColor,
          error: AppColors.accentRed,
          onPrimary: AppColors.textWhite,
          onSurface: AppColors.textWhite,
          onError: AppColors.textWhite,
        ),
        textTheme: TextTheme(
          displayLarge: AppTextStyles.heading,
          titleLarge: AppTextStyles.title,
          bodyLarge: AppTextStyles.body,
          bodyMedium: AppTextStyles.subtitle,
          labelSmall: AppTextStyles.caption,
        ),
        iconTheme: const IconThemeData(color: AppColors.textWhite),
      );
}
