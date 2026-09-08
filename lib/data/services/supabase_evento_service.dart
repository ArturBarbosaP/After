import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseEventoService {
  final SupabaseClient _client;

  SupabaseEventoService(this._client);

  Future<Map<String, dynamic>?> fetchEventoDestaque() async {
    //TODO ajustar regra de evento destaque
    //filtrar por evento ao vivo que acabou de começar ou que está quase começando,
    // mais próximo do usuário, com organizador verificado
    final emAndamento = await _client
        .from('evento_detalhado')
        .select()
        .eq('status', 'Em andamento')
        .order('data_inicio')
        .limit(1)
        .maybeSingle();

    if (emAndamento != null) return emAndamento;

    return await _client
        .from('evento_detalhado')
        .select()
        .eq('status', 'Agendado')
        .order('data_inicio')
        .limit(1)
        .maybeSingle();
  }

  Future<List<Map<String, dynamic>>> fetchEventosAoVivo() async {
    final response = await _client
        .from('evento_detalhado')
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
}