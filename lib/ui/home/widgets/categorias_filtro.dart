import 'package:after_project/domain/enums/categoria_enum.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class CategoriasFiltro extends StatelessWidget {
  final Categoria? categoriaSelecionada;
  final ValueChanged<Categoria?> onCategorySelected;

  const CategoriasFiltro({super.key, this.categoriaSelecionada, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 31,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: Categoria.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 7),
        itemBuilder: (context, index) {
          final categoria = Categoria.values[index];
          final selecionada = categoria == categoriaSelecionada;

          return ChoiceChip(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 9),
            showCheckmark: false,
            backgroundColor: AppColors.catFiltroBack,
            selectedColor: AppColors.catFiltroBackSelect,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                strokeAlign: BorderSide.strokeAlignCenter,
                color: selecionada ? AppColors.catFiltroBorderSelect : AppColors.catFiltroBorder,
                width: 1
              )
            ),
            label: Text(
              categoria.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            selected: selecionada,
            onSelected: (_) {
              onCategorySelected(selecionada ? null : categoria);
            },
          );
        },
      ),
    );
  }
}