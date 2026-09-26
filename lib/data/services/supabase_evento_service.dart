import 'package:after_project/domain/enums/categoria_enum.dart';
import 'package:after_project/domain/enums/status_enum.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseEventoService {
  final SupabaseClient _client;
  final String _nomeTabela = 'evento_detalhado';
  final String _nomeTabelaEvento = 'evento';
  final String _nomeTabelaUsuarioEvento = 'usuario_evento';

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
        .eq('status', Status.emAndamento.label)
        .order('data_inicio', ascending: true)
        .limit(10);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchEventosAoVivoPelaCategoria(Categoria categoria) async {
    final response = await _client
        .from(_nomeTabela)
        .select()
        .eq('categoria', categoria.label)
        .eq('status', Status.emAndamento.label)
        .order('data_inicio', ascending: true)
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
        .eq('status', Status.agendado.label)
        .gte('data_inicio', DateTime.now().toIso8601String())
        .order('data_inicio', ascending: true)
        .limit(3);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchProximosEventosPelaCategoria(Categoria categoria) async {
    final response = await _client
        .from(_nomeTabela)
        .select()
        .eq('status', Status.agendado.label)
        .eq('categoria', categoria.label)
        .gte('data_inicio', DateTime.now().toIso8601String())
        .order('data_inicio', ascending: true)
        .limit(3);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> fetchEventoPerto(double lat, double lng) async {

    final emAndamento = await _client.rpc(
      'get_evento_proximo',
      params: {'user_lat': lat, 'user_lng': lng},
    );

    final rows = List<Map<String, dynamic>>.from(emAndamento as List);
    return rows.isEmpty ? null : rows.first;
  }

  Future<Map<String, dynamic>?> fetchEventoPorId(int id) async {
    return await _client
        .from(_nomeTabela)
        .select()
        .eq('id', id)
        .maybeSingle();
  }

  Future<Map<String, dynamic>?> fetchStatusUsuarioEvento(String userId, int eventoId) async {
    return await _client
        .from(_nomeTabelaUsuarioEvento)
        .select('favorito, presenca')
        .eq('usuario_id', userId)
        .eq('evento_id', eventoId)
        .maybeSingle();
  }

  Future<void> upsertFavorito(String userId, int eventoId, bool favorito) async {
    return await _client
        .from(_nomeTabelaUsuarioEvento)
        .upsert(
          {'usuario_id': userId, 'evento_id': eventoId, 'favorito': favorito},
          onConflict: 'usuario_id,evento_id',
        );
  }

  Future<void> upsertPresenca(String userId, int eventoId, bool presenca) async {
    return await _client
        .from(_nomeTabelaUsuarioEvento)
        .upsert(
          {'usuario_id': userId, 'evento_id': eventoId, 'presenca': presenca},
          onConflict: 'usuario_id,evento_id',
        );
  }

  Future<Map<String, dynamic>> insertEvento(Map<String, dynamic> dados) async {
    final response = await _client
        .from(_nomeTabelaEvento)
        .insert(dados)
        .select()
        .single();
    return response;
  }

  Future<void> updateImagemCapa(int eventoId, String url) async {
    return await _client
        .from(_nomeTabelaEvento)
        .update({'imagem_capa': url})
        .eq('id', eventoId);
  }

  Future<void> updateEvento(int eventoId, Map<String, dynamic> dados) async {
    return await _client.from(_nomeTabelaEvento).update(dados).eq('id', eventoId);
  }

  Future<List<Map<String, dynamic>>> fetchMeusEventosOrganizador(String organizadorId) async {
    final response = await _client
        .from(_nomeTabelaEvento)
        .select()
        .eq('organizador_id', organizadorId)
        .order('data_inicio', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> fetchEventoOrganizadorPorId(String organizadorId, int eventoId) async {
    return await _client
        .from(_nomeTabelaEvento)
        .select()
        .eq('id', eventoId)
        .eq('organizador_id', organizadorId)
        .maybeSingle();
  }

  Future<List<Map<String, dynamic>>> fetchPesquisarMeusEventosOrganizador(String organizadorId, String titulo) async {
    final response = await _client
        .from(_nomeTabelaEvento)
        .select()
        .eq('organizador_id', organizadorId)
        .ilike('titulo', '%$titulo%')
        .order('data_inicio', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}