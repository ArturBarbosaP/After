import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseEventoService {
  final SupabaseClient _client;

  SupabaseEventoService(this._client);

  Future<Map<String, dynamic>?> fetchEventoDestaque() async {
    //TODO ajustar regra de evento destaque
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
}