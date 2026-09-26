class SupabaseCadastroEventoModel {
  int? id;
  final String dataInicio;
  final String dataFim;
  final String endereco;
  final String localizacao;
  final String titulo;
  final String descricao;
  final String categoria;
  final String status;
  final double? preco;
  String organizadorId;
  String? imagemCapa;

  SupabaseCadastroEventoModel({
    this.id,
    required this.dataInicio,
    required this.dataFim,
    required this.endereco,
    required this.localizacao,
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.status,
    this.preco,
    required this.organizadorId,
    this.imagemCapa
  });

  Map<String, dynamic> toMapSemId() {
    return {
      'data_inicio': dataInicio,
      'data_fim': dataFim,
      'endereco': endereco,
      'localizacao': localizacao,
      'titulo': titulo,
      'descricao': descricao,
      'categoria': categoria,
      'status': status,
      'preco': preco,
      'organizador_id': organizadorId,
      'imagem_capa': imagemCapa ?? ''
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data_inicio': dataInicio,
      'data_fim': dataFim,
      'endereco': endereco,
      'localizacao': localizacao,
      'titulo': titulo,
      'descricao': descricao,
      'categoria': categoria,
      'status': status,
      'preco': preco,
      'organizador_id': organizadorId,
      'imagem_capa': imagemCapa ?? ''
    };
  }
}