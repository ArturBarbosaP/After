class SupabaseEdicaoUsuarioModel {
  String? id;
  final String nome;
  final String? bio;
  final String? site;
  String? fotoPerfil;

  SupabaseEdicaoUsuarioModel({this.id, required this.nome, this.bio, this.site, this.fotoPerfil});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'bio': bio,
      'foto_perfil': fotoPerfil ?? ''
    };
  }
}