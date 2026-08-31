import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final SupabaseClient _client;

  SupabaseAuthService(this._client);

  Future<void> loginEmailSenha({required String email, required String senha}) async {
    final AuthResponse res = await _client.auth.signInWithPassword(
        email: email,
        password: senha
    );
  }
}