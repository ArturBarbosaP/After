import 'package:after_project/data/model/evento_detalhado_dto.dart';
import 'package:after_project/data/services/supabase_evento_service.dart';
import 'package:after_project/domain/models/evento_detalhado.dart';
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
}