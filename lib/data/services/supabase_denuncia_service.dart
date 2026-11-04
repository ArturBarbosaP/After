import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDenunciaService {
  final SupabaseClient _client;
  final String _nomeTabela = 'denuncia';

  SupabaseDenunciaService(this._client);

  Future<void> insertDenuncia(Map<String, dynamic> dados) async {
    await _client.from(_nomeTabela).insert(dados);
  }
}