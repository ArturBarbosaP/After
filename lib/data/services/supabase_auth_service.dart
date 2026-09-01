import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final SupabaseClient _client;

  SupabaseAuthService(this._client);

  Future<void> cadastro({
    required String nome,
    required String senha,
    required String email,
    required bool organizador
  }) async {
    final AuthResponse res = await _client.auth.signUp(
      email: email,
      password: senha,
      data: {
        'nome': nome,
        'is_organizador': organizador
      }
    );
  }

  Future<void> loginEmailSenha({required String email, required String senha}) async {
    final AuthResponse res = await _client.auth.signInWithPassword(
        email: email,
        password: senha
    );
  }
}