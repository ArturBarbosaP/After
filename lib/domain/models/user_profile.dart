class UserProfile {
  final String id;
  final String nome;
  final String? urlFotoPerfil;
  final String? bio;
  String? site;

  UserProfile({required this.id, required this.nome, this.urlFotoPerfil, this.bio, this.site});
}