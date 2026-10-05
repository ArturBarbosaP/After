import 'package:after_project/data/services/supabase_auth_service.dart';
import 'package:after_project/data/model/supabase_cadastro_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer' as developer;

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
    } on AuthException catch (ex, stackTrace) {
      developer.log(
        'Falha no cadastro - AuthException',
        name: 'AuthRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw AuthFailure(_traduzirAuthError(ex));
    }
    catch (ex, stackTrace) {
      developer.log(
        'Falha no cadastro - Exception',
        name: 'AuthRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw AuthFailure("Não foi possível fazer o cadastro. Tente novamente.");
    }
  }

  Future<void> login({required String email, required String senha}) async {
    try {
      await _authService.loginEmailSenha(email: email, senha: senha);
    }
    on AuthException catch (ex, stackTrace) {
      developer.log(
        'Falha no login com email e senha - AuthException',
        name: 'AuthRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw AuthFailure(_traduzirAuthError(ex));
    }
    catch (ex, stackTrace) {
      developer.log(
        'Falha no login com email e senha - Exception',
        name: 'AuthRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw AuthFailure("Não foi possível fazer o login. Tente novamente.");
    }
  }

  Future<void> loginGoogle() async {
    try {
      await _authService.loginGoogle();
    }
    on GoogleSignInException catch (ex, stackTrace) {
      developer.log(
        'Falha no login com Google - GoogleSignInException',
        name: 'AuthRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw AuthFailure('Login com o Google cancelado');
    }
    on AuthException catch (ex, stackTrace) {
      developer.log(
        'Falha no login com Google - AuthException',
        name: 'AuthRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw AuthFailure(_traduzirAuthError(ex));
    }
    catch (ex, stackTrace) {
      developer.log(
        'Falha no login com Google - Exception',
        name: 'AuthRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw AuthFailure('Não foi possível entrar com o Google. Tente novamente.');
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    }
    on AuthException catch (ex, stackTrace) {
      developer.log(
        'Falha no logout - AuthException',
        name: 'AuthRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw AuthFailure(_traduzirAuthError(ex));
    }
    catch (ex, stackTrace) {
      developer.log(
        'Falha no logout - Exception',
        name: 'AuthRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw AuthFailure("Não foi possível fazer o logout. Tente novamente.");
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