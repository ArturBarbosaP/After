import 'package:after_project/domain/models/mensagem_comunidade.dart';

class MensagemComunidadeDto {
  final String id;
  final String autorId;
  final String autorNome;
  final String? autorUrlFoto;
  final String texto;
  final String enviadaEm;

  MensagemComunidadeDto({
    required this.id,
    required this.autorId,
    required this.autorNome,
    this.autorUrlFoto,
    required this.texto,
    required this.enviadaEm,
  });

  factory MensagemComunidadeDto.fromJson(Map<String, dynamic> json) {
    return MensagemComunidadeDto(
      id: json['id'] as String,
      autorId: json['autor_id'] as String,
      autorNome: json['autor_nome'] as String,
      autorUrlFoto: json['autor_url_foto'] as String?,
      texto: json['texto'] as String,
      enviadaEm: json['enviado_em'] as String,
    );
  }

  MensagemComunidade toDomain() {
    return MensagemComunidade(
      id: id,
      autorId: autorId,
      autorNome: autorNome,
      autorUrlFoto: autorUrlFoto,
      texto: texto,
      enviadaEm: DateTime.parse(enviadaEm),
    );
  }

  Map<String, dynamic> toMap(int eventoId){
    return {
      'evento_id': eventoId,
      'autor_id': autorId,
      'autor_nome': autorNome,
      'autor_url_foto': autorUrlFoto,
      'texto': texto,
      'enviado_em': enviadaEm
    };
  }
}