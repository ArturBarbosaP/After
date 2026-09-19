import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseEventoService {
  final SupabaseClient _client;
  final String _nomeTabela = 'evento_detalhado';

  SupabaseEventoService(this._client);

  Future<Map<String, dynamic>?> fetchEventoDestaque(double lat, double lng) async {

    final emAndamento = await _client.rpc(
      'get_evento_destaque',
      params: {'user_lat': lat, 'user_lng': lng},
    );

    final rows = List<Map<String, dynamic>>.from(emAndamento as List);
    return rows.isEmpty ? null : rows.first;
  }

  Future<List<Map<String, dynamic>>> fetchEventosAoVivo() async {
    final response = await _client
        .from(_nomeTabela)
        .select()
        .eq('status', 'Em andamento')
        .order('data_inicio')
        .limit(10);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchAmigosPresentes(int eventoId) async {
    final response = await _client.rpc(
      'get_amigos_presentes',
      params: {'p_evento_id': eventoId},
    );

    return List<Map<String, dynamic>>.from(response as List);
  }

  Future<List<Map<String, dynamic>>> fetchProximosEventos() async {
    final response = await _client
        .from(_nomeTabela)
        .select()
        .eq('status', 'Agendado')
        .gte('data_inicio', DateTime.now().toIso8601String())
        .order('data_inicio')
        .limit(3);

    return List<Map<String, dynamic>>.from(response);
  }
}