import 'package:google_sign_in/google_sign_in.dart';
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

  Future<void> loginGoogle() async {
    final googleSignIn = GoogleSignIn.instance;

    final googleUser = await googleSignIn.attemptLightweightAuthentication()
        ?? await googleSignIn.authenticate();

    const scopes = ['email', 'profile'];
    final authorization =
        await googleUser.authorizationClient.authorizationForScopes(scopes) ??
        await googleUser.authorizationClient.authorizeScopes(scopes);

    final idToken = googleUser.authentication.idToken;
    if (idToken == null ){
      throw const AuthException('No ID Token found.');
    }

    final AuthResponse res = await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: authorization.accessToken
    );
  }

  Future<void> logout() async {
    await _client.auth.signOut(scope: SignOutScope.global);
  }
}