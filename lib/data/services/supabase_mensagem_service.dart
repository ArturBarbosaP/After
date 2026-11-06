import 'package:supabase_flutter/supabase_flutter.dart';
 
class SupabaseMensagemService {
  final SupabaseClient _client;
  final String _nomeTabela = 'mensagem';
 
  SupabaseMensagemService(this._client);
 
  Future<List<Map<String, dynamic>>> fetchMensagens(int eventoId) async {
    final response = await _client
        .from(_nomeTabela)
        .select()
        .eq('evento_id', eventoId)
        .order('enviado_em', ascending: true);
 
    return List<Map<String, dynamic>>.from(response);
  }
 
  Future<void> enviarMensagem(Map<String, dynamic> dados) async {
    return await _client.from(_nomeTabela).insert(dados);
  }
 
  Future<void> removerMensagem(String mensagemId) async {
    final linhas = await _client
        .from(_nomeTabela)
        .update({'removida': true})
        .eq('id', mensagemId)
        .select('id');
 
    // Se o banco bloquear a alteração, ele não dá erro, só devolve lista vazia.
    if (linhas.isEmpty) {
      throw Exception('Nenhuma linha atualizada (sem permissão ou mensagem inexistente).');
    }
  }
 
  RealtimeChannel escutarMensagens({
    required int eventoId,
    required void Function(Map<String, dynamic> novaMensagem) onNovaMensagem,
    required void Function(Map<String, dynamic> mensagemAtualizada) onMensagemAtualizada,
  }) {
    final channel = _client.channel('mensagens_evento_$eventoId');
 
    final filtro = PostgresChangeFilter(
      type: PostgresChangeFilterType.eq,
      column: 'evento_id',
      value: eventoId,
    );
 
    channel
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'after_dev',
          table: _nomeTabela,
          filter: filtro,
          callback: (payload) => onNovaMensagem(payload.newRecord),
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'after_dev',
          table: _nomeTabela,
          filter: filtro,
          callback: (payload) => onMensagemAtualizada(payload.newRecord),
        )
        .subscribe();
 
    return channel;
  }
 
  Future<void> pararDeEscutar(RealtimeChannel channel) {
    return _client.removeChannel(channel);
  }
}