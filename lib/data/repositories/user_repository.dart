import 'package:after_project/data/model/user_profile_dto.dart';
import 'package:after_project/data/services/supabase_user_service.dart';
import 'package:after_project/domain/models/user_profile.dart';
import 'dart:developer' as developer;

class UserFailure implements Exception {
  final String message;
  UserFailure(this.message);
}

class UserRepository {
  final SupabaseUserService _userService;

  UserRepository(this._userService);

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
}