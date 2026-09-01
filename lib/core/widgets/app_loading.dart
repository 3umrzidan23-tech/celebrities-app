import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppLoading extends StatelessWidget {
  final Color color;
  const AppLoading({super.key, this.color = AppColors.primaryBlue});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
