import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final double size;
  final String letter;
  final double fontSize;
  final double? borderRadius;
  final BoxBorder? border;
  final String? imageUrl;

  const AppAvatar({
    super.key,
    this.size = 45,
    this.letter = 'U',
    this.fontSize = 20,
    this.borderRadius,
    this.border,
    this.imageUrl = '',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            imageUrl != null && imageUrl!.isNotEmpty ? imageUrl! : '',
          )
        ),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.fotoGradA, AppColors.fotoGradB],
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? size / 2),
        border: border,
      ),
      child:
      Text(
        imageUrl != null && imageUrl!.isNotEmpty ? '' : letter,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
          color: Colors.white,
        ),
      ),
    );
  }
}