import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class AppSearchField extends StatelessWidget {
  final VoidCallback onPesquisarTap;
  final TextEditingController controller;

  const AppSearchField({
    super.key,
    required this.onPesquisarTap,
    required this.controller
  });

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: const BorderSide(color: AppColors.textboxBorder, width: 1)
    );

    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        hintText: 'Procurar eventos',
        hintStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: AppColors.searchBackground,
        suffixIcon: IconButton(
          icon: Icon(Icons.search_outlined),
          onPressed: onPesquisarTap
        ),
        suffixIconColor: Colors.white,
        border: borderStyle,
        enabledBorder: borderStyle,
        focusedBorder: borderStyle.copyWith(
          borderSide: const BorderSide(color: AppColors.textboxBorder, width: 2)
        )
      ),
    );
  }
}