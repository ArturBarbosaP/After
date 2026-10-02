class MensagemComunidade {
  final int id;
  final int autorId;
  final String autorNome;
  final String? autorUrlFoto;
  final String texto;
  final DateTime enviadaEm;
 
  const MensagemComunidade({
    required this.id,
    required this.autorId,
    required this.autorNome,
    this.autorUrlFoto,
    required this.texto,
    required this.enviadaEm,
  });
}