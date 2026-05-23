import '../../../../core/theme/constants/app_colors.dart';
import '../../../../core/theme/constants/app_dimensions.dart';
import 'package:flutter/material.dart';



class AppIconWidget extends StatelessWidget {
  final IconData? iconData;
  final Color? color;
  final double? size;

  const AppIconWidget({
    super.key,
    this.iconData,
    this.color = AppColors.gray50,
    this.size = AppDimensions.iconSize24,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      color: color,
      size: size,
    );
  }
}
