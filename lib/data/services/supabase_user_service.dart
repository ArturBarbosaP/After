import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseUserService {
  final SupabaseClient _client;
  final String nomeTabela = 'usuario';

  SupabaseUserService(this._client);

  String? get currentUserId => _client.auth.currentUser?.id;

  Future<Map<String, dynamic>?> fetchUsuario(String id) async {
    return await _client
        .from(nomeTabela)
        .select('id, nome, foto_perfil')
        .eq('id', id)
        .maybeSingle();
  }
}