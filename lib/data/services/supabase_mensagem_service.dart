import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseMensagemService {
  final SupabaseClient _client;
  final String _nomeTabela = 'mensagem';

  SupabaseMensagemService(this._client);

  Future<List<Map<String, dynamic>>> fetchMensagens(int eventoId) async {
    final response = await _client
        .from(_nomeTabela)
        .select()
        .eq('evento_id', eventoId);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> enviarMensagem(Map<String, dynamic> dados) async {
    return await _client
        .from(_nomeTabela)
        .insert(dados);
  }

  RealtimeChannel escutarMensagens({required int eventoId, required void Function(Map<String, dynamic> novaMensagem) onNovaMensagem}) {
    final channel = _client.channel('mensagens_evento_$eventoId');

    channel.onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'after_dev',
      table: _nomeTabela,
      filter: PostgresChangeFilter(
        type: PostgresChangeFilterType.eq,
        column: 'evento_id',
        value: eventoId,
      ),
      callback: (payload) => onNovaMensagem(payload.newRecord),
    ).subscribe();

    return channel;
  }

  Future<void> pararDeEscutar(RealtimeChannel channel) {
    return _client.removeChannel(channel);
  }
}