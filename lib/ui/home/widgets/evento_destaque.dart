import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class EventoDestaque extends StatelessWidget {
  final VoidCallback onTap;
  final String status;
  final String titulo;
  final String endereco;

  const EventoDestaque({super.key, required this.onTap, required this.status, required this.titulo, required this.endereco});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(17),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [AppColors.emDestaqueGradA, AppColors.emDestaqueGradB],
            )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 17, vertical: 8),
                  decoration: BoxDecoration(
                      color: status == 'Em andamento'
                          ? AppColors.aoVivoBackground
                          : AppColors.agendadoBackground,
                      borderRadius: BorderRadius.circular(33),
                      border: Border.all(
                          width: 1,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: status == 'Em andamento'
                              ? AppColors.aoVivoBorder
                              : AppColors.agendadoBorder
                      )
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      endereco,
                      textAlign: TextAlign.end,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}