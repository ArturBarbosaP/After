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
  final String imagemCapa;
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
}