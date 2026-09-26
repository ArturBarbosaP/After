import 'package:after_project/domain/enums/categoria_enum.dart';
import 'package:after_project/domain/enums/status_enum.dart';
import 'package:after_project/domain/models/evento.dart';

class EventoDto {
  final int id;
  final String dataInicio;
  final String dataFim;
  final String endereco;
  final String localizacao;
  final String titulo;
  final String descricao;
  final String categoria;
  final String status;
  final String? imagemCapa;
  final double? preco;
  final String organizadorId;

  EventoDto({
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
    required this.organizadorId
  });

  factory EventoDto.fromJson(Map<String, dynamic> json){
    return EventoDto(
      id: json['id'] as int,
      dataInicio: json['data_inicio'] as String,
      dataFim: json['data_fim'] as String,
      endereco: json['endereco'] as String,
      localizacao: json['localizacao'] as String,
      titulo: json['titulo'] as String,
      descricao: json['descricao'] as String,
      categoria: json['categoria'] as String,
      status: json['status'] as String,
      imagemCapa: json['imagem_capa'] as String?,
      preco: (json['preco'] as num?)?.toDouble(),
      organizadorId: json['organizador_id'] as String,
    );
  }

  Evento toDomain() {
    return Evento(
      id: id,
      dataInicio: DateTime.parse(dataInicio),
      dataFim: DateTime.parse(dataFim),
      endereco: endereco,
      localizacao: localizacao,
      titulo: titulo,
      descricao: descricao,
      categoria: Categoria.fromString(categoria),
      status: Status.fromString(status),
      imagemCapa: imagemCapa == '' ? null : imagemCapa,
      preco: preco == 0 ? null : preco,
      organizadorId: organizadorId
    );
  }
}