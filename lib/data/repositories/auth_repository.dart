import 'package:after_project/data/services/supabase_auth_service.dart';
import 'package:after_project/data/model/supabase_cadastro_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthFailure implements Exception {
  final String message;
  AuthFailure(this.message);
}

class AuthRepository {
  final SupabaseAuthService _authService;

  AuthRepository(this._authService);

  Future<void> cadastro({required SupabaseCadastroModel model}) async {
    try{
      await _authService.cadastro(
        nome: model.nome,
        email: model.email,
        senha: model.senha,
        organizador: model.organizador
      );
    } on AuthException catch (ex) {
      throw AuthFailure(_traduzirAuthError(ex));
    }
    catch (_){
      throw AuthFailure("Não foi possível fazer o cadastro. Tente novamente.");
    }
  }

  Future<void> login({required String email, required String senha}) async {
    try {
      await _authService.loginEmailSenha(email: email, senha: senha);
    }
    on AuthException catch (ex) {
      throw AuthFailure(_traduzirAuthError(ex));
    }
    catch(_){
      throw AuthFailure("Não foi possível fazer o login. Tente novamente.");
    }
  }

  String _traduzirAuthError(AuthException e) {
    switch (e.message) {
      case 'User already registered':
        return 'Já existe uma conta com esse email!';
      case 'Invalid login credentials':
        return 'Email ou senha incorretos!';
      default:
        return e.message;
    }
  }
}