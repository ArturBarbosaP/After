import 'package:flutter/material.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool esconderTexto;

  final String? Function(String?)? validator;
  final Widget? iconeFim;
  final Widget? iconeComeco;
  final TextInputType? tipoInput;

  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.esconderTexto = false,
    this.validator,
    this.iconeFim,
    this.iconeComeco,
    this.tipoInput
  });

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.textboxBorder, width: 1)
    );

    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: esconderTexto,
      keyboardType: tipoInput,
      style: const TextStyle(color: AppColors.textboxText),
      cursorColor: AppColors.textboxText,
      decoration: InputDecoration(
        hintText: label,
        hintStyle: const TextStyle(color: AppColors.textboxText),
        filled: true,
        fillColor: AppColors.textboxBackground,
        suffixIcon: iconeFim,
        suffixIconColor: AppColors.textboxIcon,
        prefixIcon: iconeComeco,
        prefixIconColor: AppColors.textboxIcon,
        border: borderStyle,
        enabledBorder: borderStyle,
        focusedBorder: borderStyle.copyWith(
          borderSide: const BorderSide(color: AppColors.textboxBorder, width: 2)
        )
      ),
    );
  }
}