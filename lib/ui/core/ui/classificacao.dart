import 'package:after_project/domain/enums/classificacao_enum.dart';
import 'package:flutter/material.dart';

class AppClassificacao extends StatelessWidget {
  const AppClassificacao({super.key, required this.classificacao, this.size = 40});

  final Classificacao classificacao;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/classificacao/${classificacao.label}.png',
      fit: BoxFit.cover,
      width: size,
      height: size,
    );
  }
}