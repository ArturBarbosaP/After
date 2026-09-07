import 'package:after_project/domain/enums/categoria_enum.dart';
import 'package:after_project/domain/enums/status_enum.dart';
import 'package:after_project/domain/models/evento_detalhado.dart';

class EventoDetalhadoDto {
  final int id;
  final String dataInicio;
  final String dataFim;
  final String endereco;

  final String titulo;
  final String descricao;
  final String categoria;
  final String status;
  final String imagemCapa;
  final String organizadorId;
  final String organizadorSite;
  final bool organizadorVerificado;
  final String organizadorNome;
  final String? organizadorFoto;
  final String? organizadorBio;

  EventoDetalhadoDto({
    required this.id,
    required this.dataInicio,
    required this.dataFim,
    required this.endereco,
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.status,
    required this.imagemCapa,
    required this.organizadorId,
    required this.organizadorSite,
    required this.organizadorVerificado,
    required this.organizadorNome,
    this.organizadorFoto,
    this.organizadorBio
  });

  factory EventoDetalhadoDto.fromJson(Map<String, dynamic> json){
    return EventoDetalhadoDto(
      id: json['id'] as int,
      dataInicio: json['data_inicio'] as String,
      dataFim: json['data_fim'] as String,
      endereco: json['endereco'] as String,

      titulo: json['titulo'] as String,
      descricao: json['descricao'] as String,
      categoria: json['categoria'] as String,
      status: json['status'] as String,
      imagemCapa: json['imagem_capa'] as String,
      organizadorId: json['organizador_id'] as String,
      organizadorSite: json['organizador_site'] as String,
      organizadorVerificado: json['organizador_verificado'] as bool,
      organizadorNome: json['organizador_nome'] as String,
      organizadorFoto: json['organizador_foto'] as String?,
      organizadorBio: json['organizador_bio'] as String?
    );
  }

  EventoDetalhado toDomain() {
    return EventoDetalhado(
      id: id,
      dataInicio: DateTime.parse(dataInicio),
      dataFim: DateTime.parse(dataFim),
      endereco: endereco,
      titulo: titulo,
      descricao: descricao,
      categoria: Categoria.fromString(categoria),
      status: Status.fromString(status),
      imagemCapa: imagemCapa,
      organizadorId: organizadorId,
      organizadorSite: organizadorSite,
      organizadorVerificado: organizadorVerificado,
      organizadorNome: organizadorNome,
      organizadorFoto: organizadorFoto,
      organizadorBio: organizadorBio
    );
  }
}