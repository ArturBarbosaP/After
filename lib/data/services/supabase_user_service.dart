import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseUserService {
  final SupabaseClient _client;
  final String _nomeTabela = 'usuario';
  final String _nomeTabelaOrganizador = 'organizador';

  SupabaseUserService(this._client);

  String? get currentUserId => _client.auth.currentUser?.id;

  Future<Map<String, dynamic>?> fetchUsuario(String id) async {
    return await _client
        .from(_nomeTabela)
        .select('id, nome, foto_perfil, bio')
        .eq('id', id)
        .maybeSingle();
  }

  Future<Map<String, dynamic>?> fetchOrganizador(String id) async {
    return await _client
        .from(_nomeTabelaOrganizador)
        .select()
        .eq('id', id)
        .maybeSingle();
  }
}