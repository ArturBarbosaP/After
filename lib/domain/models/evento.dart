import 'package:after_project/domain/enums/categoria_enum.dart';
import 'package:after_project/domain/enums/status_enum.dart';

class Evento {
  final int id;
  final DateTime dataInicio;
  final DateTime dataFim;
  final String endereco;
  final String localizacao;
  final String titulo;
  final String descricao;
  final Categoria categoria;
  final Status status;
  final String? imagemCapa;
  final double? preco;
  final String organizadorId;

  Evento({
    required this.id,
    required this.dataInicio,
    required this.dataFim,
    required this.endereco,
    required this.localizacao,
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.status,
    this.imagemCapa,
    this.preco,
    required this.organizadorId,
  });
}