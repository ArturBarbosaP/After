class UserProfile {
  final String id;
  final String nome;
  final String? urlFotoPerfil;
  final String? bio;
  final bool verificado;
  String? site;

  UserProfile({required this.id, required this.nome, this.urlFotoPerfil, this.bio, required this.verificado, this.site});
}