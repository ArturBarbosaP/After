import 'dart:typed_data';
import 'package:after_project/data/model/organizador_dto.dart';
import 'package:after_project/data/model/supabase_edicao_usuario_model.dart';
import 'package:after_project/data/model/user_profile_dto.dart';
import 'package:after_project/data/services/supabase_storage_service.dart';
import 'package:after_project/data/services/supabase_user_service.dart';
import 'package:after_project/domain/models/organizador.dart';
import 'package:after_project/domain/models/user_profile.dart';
import 'package:after_project/utils/datetime_helper.dart';
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

  Future<({bool ok, String? mensagem})> verificar({
    required String id,
    required bool isOrganizador,
    required String documento,
    required DateTime dataNascimento
  }) async {
    try {
      String? mensagem;
      bool ok = true;
      if (isOrganizador){
        mensagem = null;
        ok = false;
      }
      else {
        final anos = diferencaEmAnos(DateTime.now(), dataNascimento);

        if (anos < 18){
          return (ok: false, mensagem: 'Você deve ter mais de 18 anos para realizar a verificação!');
        }

        await _userService.verificarUsuario(id);
        mensagem = null;
        ok = true;
      }
      return (ok: ok, mensagem: mensagem);
    }  catch (ex, stackTrace) {
      developer.log(
        'Falha ao verificar perfil - Exception',
        name: 'UserRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw UserFailure("Não foi possível verificar o perfil. Tente novamente.");
    }
  }
}