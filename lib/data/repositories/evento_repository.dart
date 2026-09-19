import 'package:after_project/data/model/evento_detalhado_dto.dart';
import 'package:after_project/data/services/supabase_evento_service.dart';
import 'package:after_project/domain/models/evento_detalhado.dart';
import 'package:after_project/domain/models/user_profile.dart';
import 'dart:developer' as developer;

class EventoFailure implements Exception {
  final String message;
  EventoFailure(this.message);
}

class EventoRepository {
  final SupabaseEventoService _eventoService;

  EventoRepository(this._eventoService);

  Future<EventoDetalhado?> getEventoDestaque(double lat, double lng) async {
    try{
      final json = await _eventoService.fetchEventoDestaque(lat, lng);
      if (json == null) return null;

      return EventoDetalhadoDto.fromJson(json).toDomain();
    } catch (ex, stackTrace) {
      developer.log(
          'Falha ao recuperar evento destaque - Exception',
          name: 'EventoRepository',
          error: ex,
          stackTrace: stackTrace
      );
      throw EventoFailure("Não foi possível recuperar o evento destaque. Tente novamente.");
    }
  }

  Future<List<EventoDetalhado>> getEventosAoVivo() async {
    try{
      final rows = await _eventoService.fetchEventosAoVivo();
      return rows.map((json) => EventoDetalhadoDto.fromJson(json).toDomain()).toList();
    } catch (ex, stackTrace) {
      developer.log(
          'Falha ao recuperar lista de eventos ao vivo - Exception',
          name: 'EventoRepository',
          error: ex,
          stackTrace: stackTrace
      );
      throw EventoFailure("Não foi possível recuperar os eventos ao vivo. Tente novamente.");
    }
  }

  Future<List<UserProfile>> getAmigosPresentes(int eventoId) async {
    try{
      final rows = await _eventoService.fetchAmigosPresentes(eventoId);

      return rows.map((json) => UserProfile(
        id: json['usuario_id'] as String,
        nome: json['nome'] as String,
        urlFotoPerfil: json['foto_perfil'] as String?,
      )).toList();
    } catch (ex, stackTrace) {
      developer.log(
          'Falha ao recuperar lista de amigos presentes no evento - Exception',
          name: 'EventoRepository',
          error: ex,
          stackTrace: stackTrace
      );
      throw EventoFailure("Não foi possível recuperar os amigos presentes no evento. Tente novamente.");
    }
  }

  Future<List<EventoDetalhado>> getProximosEventos() async {
    try {
      final rows = await _eventoService.fetchProximosEventos();

      return rows.map((json) => EventoDetalhadoDto.fromJson(json).toDomain()).toList();
    } catch (ex, stackTrace) {
      developer.log(
          'Falha ao recuperar próximos eventos - Exception',
          name: 'EventoRepository',
          error: ex,
          stackTrace: stackTrace
      );
      throw EventoFailure("Não foi possível recuperar os próximos eventos. Tente novamente.");
    }
  }

  Future<EventoDetalhado?> getEventoPerto(double lat, double lng) async {
    try{
      final json = await _eventoService.fetchEventoPerto(lat, lng);
      if (json == null) return null;

      return EventoDetalhadoDto.fromJson(json).toDomain();
    } catch (ex, stackTrace) {
      developer.log(
          'Falha ao recuperar evento perto - Exception',
          name: 'EventoRepository',
          error: ex,
          stackTrace: stackTrace
      );
      throw EventoFailure("Não foi possível recuperar o evento mais próximo. Tente novamente.");
    }
  }

  Future<EventoDetalhado?> getEventoPorId(int id) async {
    try {
      final json = await _eventoService.fetchEventoPorId(id);
      if (json == null) return null;

      return EventoDetalhadoDto.fromJson(json).toDomain();
    } catch (ex, stackTrace) {
      developer.log(
          'Falha ao recuperar evento pelo id - Exception',
          name: 'EventoRepository',
          error: ex,
          stackTrace: stackTrace
      );
      throw EventoFailure("Não foi possível recuperar o evento pelo id. Tente novamente.");
    }
  }

  Future<void> setFavorito(String userId, int eventoId, bool favorito) async {
    try {
      return await _eventoService.upsertFavorito(userId, eventoId, favorito);
    } catch (ex, stackTrace) {
      developer.log(
          'Falha ao setar evento como favorito - Exception',
          name: 'EventoRepository',
          error: ex,
          stackTrace: stackTrace
      );
      throw EventoFailure("Não foi possível favoritar o evento. Tente novamente.");
    }
  }

  Future<void> setPresenca(String userId, int eventoId, bool presenca) async {
    try {
      return await _eventoService.upsertPresenca(userId, eventoId, presenca);
    } catch (ex, stackTrace) {
      developer.log(
          'Falha ao setar presença no evento - Exception',
          name: 'EventoRepository',
          error: ex,
          stackTrace: stackTrace
      );
      throw EventoFailure("Não foi possível marcar presença no evento. Tente novamente.");
    }
  }

  Future<({bool favorito, bool presenca})> getStatusUsuarioEvento(String userId, int eventoId) async {
    try {
      final json = await _eventoService.fetchStatusUsuarioEvento(userId, eventoId);

      return (
        favorito: json?['favorito'] as bool? ?? false,
        presenca: json?['presenca'] as bool? ?? false,
      );
    } catch (ex, stackTrace) {
      developer.log(
          'Falha ao recuperar usuario evento - Exception',
          name: 'EventoRepository',
          error: ex,
          stackTrace: stackTrace
      );
      throw EventoFailure("Não foi possível recuperar usuário pro evento. Tente novamente.");
    }
  }

}