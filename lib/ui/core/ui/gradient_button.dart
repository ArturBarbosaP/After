import 'package:flutter/material.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double? width;
  final double height;
  final Gradient? gradient;
  final double borderRadius;
  final BoxBorder? border;
  final TextStyle textStyle;

  const GradientButton({
    super.key,
    required this.text,
    this.onTap,
    this.width,
    this.height = 40,
    this.gradient,
    this.borderRadius = 5,
    this.border,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: gradient ?? LinearGradient(
            colors: [AppColors.btnGradA, AppColors.btnGradB],
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          border: border ??
              Border.all(color: AppColors.buttonBorder, width: 1),
        ),
        child: Text(text, style: textStyle),
      ),
    );
  }
}