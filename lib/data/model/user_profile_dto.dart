import 'package:after_project/domain/models/user_profile.dart';

class UserProfileDto {
  final String id;
  final String nome;
  final String? fotoPerfil;
  final String? bio;
  final bool verificado;

  UserProfileDto({required this.id, required this.nome, this.fotoPerfil, this.bio, required this.verificado});

  factory UserProfileDto.fromJson(Map<String, dynamic> json){
    return UserProfileDto(
      id: json['id'] as String,
      nome: json['nome'] as String,
      fotoPerfil: json['foto_perfil'] as String?,
      bio: json['bio'] as String?,
      verificado: json['verificado'] as bool
    );
  }

  UserProfile toDomain() {
    return UserProfile(id: id, nome: nome, urlFotoPerfil: fotoPerfil, bio: bio, verificado: verificado);
  }
}