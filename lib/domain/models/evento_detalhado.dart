import 'package:after_project/domain/enums/categoria_enum.dart';
import 'package:after_project/domain/enums/classificacao_enum.dart';
import 'package:after_project/domain/enums/status_enum.dart';

class EventoDetalhado {
  final int id;
  final DateTime dataInicio;
  final DateTime dataFim;
  final String endereco;
  final String titulo;
  final String descricao;
  final Categoria categoria;
  final Status status;
  final Classificacao classificacao;
  final String? imagemCapa;
  final double? preco;
  final String organizadorId;
  final String organizadorSite;
  final bool organizadorVerificado;
  final String organizadorNome;
  final String? organizadorFoto;
  final String? organizadorBio;
  final double? distancia;

  EventoDetalhado({
    required this.id,
    required this.dataInicio,
    required this.dataFim,
    required this.endereco,
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.status,
    required this.classificacao,
    this.imagemCapa,
    this.preco,
    required this.organizadorId,
    required this.organizadorSite,
    required this.organizadorVerificado,
    required this.organizadorNome,
    this.organizadorFoto,
    this.organizadorBio,
    this.distancia
  });
}