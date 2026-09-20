class SupabaseCadastroEventoModel {
  final int id;
  final String dataInicio;
  final String dataFim;
  final String endereco;
  final String localizacao;
  final String titulo;
  final String descricao;
  final String categoria;
  final String status;
  String imagemCapa;
  final double? preco;
  final String organizadorId;

  SupabaseCadastroEventoModel({
    required this.id,
    required this.dataInicio,
    required this.dataFim,
    required this.endereco,
    required this.localizacao,
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.status,
    required this.imagemCapa,
    this.preco,
    required this.organizadorId
  });

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
      'imagem_capa': status,
      'imagemCapa': imagemCapa,
      'preco': preco,
      'organizador_id': organizadorId
    };
  }
}