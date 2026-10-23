import 'dart:typed_data';
import 'package:after_project/data/model/organizador_dto.dart';
import 'package:after_project/data/model/supabase_edicao_usuario_model.dart';
import 'package:after_project/data/model/user_profile_dto.dart';
import 'package:after_project/data/services/supabase_storage_service.dart';
import 'package:after_project/data/services/supabase_user_service.dart';
import 'package:after_project/domain/models/organizador.dart';
import 'package:after_project/domain/models/user_profile.dart';
import 'dart:developer' as developer;

class UserFailure implements Exception {
  final String message;
  UserFailure(this.message);
}

class UserRepository {
  final SupabaseUserService _userService;
  final SupabaseStorageService _storageService;

  UserRepository(this._userService, this._storageService);

  Future<UserProfile?> getUsuarioAtual() async {
    try {
      final userId = _userService.currentUserId;
      if (userId == null) return null;

      final json = await _userService.fetchUsuario(userId);
      if (json == null) return null;

      return UserProfileDto.fromJson(json).toDomain();
    } catch (ex, stackTrace) {
      developer.log(
        'Falha ao recuperar usuario - Exception',
        name: 'UserRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw UserFailure("Não foi possível recuperar o usuário. Tente novamente.");
    }
  }

  Future<Organizador?> getOrganizadorAtual() async {
    try {
      final userId = _userService.currentUserId;
      if (userId == null) return null;

      final json = await _userService.fetchOrganizador(userId);
      if (json == null) return null;

      return OrganizadorDto.fromJson(json).toDomain();
    } catch (ex, stackTrace) {
      developer.log(
        'Falha ao recuperar organizador - Exception',
        name: 'UserRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw UserFailure("Não foi possível recuperar o organizador. Tente novamente.");
    }
  }

  Future<void> editar({
    required String id,
    required SupabaseEdicaoUsuarioModel model,
    required bool organizador,
    Uint8List? novaImagem
  }) async {
    try {
      await _userService.updateUsuario(id, model.toMap());

      if (organizador){
        await _userService.updateOrganizador(id, model.site!);
      }

      if (novaImagem != null) {
        final url = await _storageService.uploadFotoPerfil(
            usuarioId: id,
            bytes: novaImagem
        );

        await _userService.updateImagemPerfil(id, url);
      }
    }  catch (ex, stackTrace) {
      developer.log(
        'Falha ao editar perfil - Exception',
        name: 'UserRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw UserFailure("Não foi possível editar o perfil. Tente novamente.");
    }
  }
}