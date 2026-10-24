class SupabaseEdicaoUsuarioModel {
  String? id;
  final String nome;
  final String? bio;
  final String? site;
  final bool verificado;
  String? fotoPerfil;

  SupabaseEdicaoUsuarioModel({this.id, required this.nome, this.bio, this.site, required this.verificado, this.fotoPerfil});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'bio': bio,
      'verificado': verificado,
      'foto_perfil': fotoPerfil ?? ''
    };
  }
}