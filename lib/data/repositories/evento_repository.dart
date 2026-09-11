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

  Future<EventoDetalhado?> getEventoDestaque() async {
    try{
      final json = await _eventoService.fetchEventoDestaque();
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
}