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

  Future<void> updateImagemPerfil(String id, String url) async {
    return await _client
        .from(_nomeTabela)
        .update({'foto_perfil': url})
        .eq('id', id);
  }

  Future<void> updateUsuario(String id, Map<String, dynamic> dados) async {
    return await _client.from(_nomeTabela).update(dados).eq('id', id);
  }

  Future<void> updateOrganizador(String id, String site) async {
    return await _client.from(_nomeTabelaOrganizador).update({'site': site}).eq('id', id);
  }
}