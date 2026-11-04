class SupabaseDenunciaModel {
  final String criadoEm;
  final String? usuarioId;
  final int? eventoId;
  final String descricao;

  SupabaseDenunciaModel({
    required this.criadoEm,
    this.usuarioId,
    this.eventoId,
    required this.descricao
  });

  Map<String, dynamic> toMap() {
    return {
      'criado_em': criadoEm,
      'usuario_id': usuarioId,
      'evento_id': eventoId,
      'descricao': descricao
    };
  }
}