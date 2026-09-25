import 'dart:typed_data';
import 'package:after_project/data/model/evento_detalhado_dto.dart';
import 'package:after_project/data/model/evento_dto.dart';
import 'package:after_project/data/model/supabase_cadastro_evento_model.dart';
import 'package:after_project/data/services/supabase_evento_service.dart';
import 'package:after_project/data/services/supabase_storage_service.dart';
import 'package:after_project/domain/models/evento.dart';
import 'package:after_project/domain/models/evento_detalhado.dart';
import 'package:after_project/domain/models/user_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:developer' as developer;

class EventoFailure implements Exception {
  final String message;
  EventoFailure(this.message);
}

class EventoRepository {
  final SupabaseEventoService _eventoService;
  final SupabaseStorageService _storageService;

  EventoRepository(this._eventoService, this._storageService);

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

  Future<List<Evento>> getMeusEventosOrganizador(String organizadorId) async {
    try {
      final rows = await _eventoService.fetchMeusEventosOrganizador(organizadorId);
      return rows.map((json) => EventoDto.fromJson(json).toDomain()).toList();
    } catch (ex, stackTrace) {
      developer.log(
          'Falha ao recuperar eventos do organizador - Exception',
          name: 'EventoRepository',
          error: ex,
          stackTrace: stackTrace
      );
      throw EventoFailure("Não foi possível recuperar os eventos. Tente novamente.");
    }
  }

  Future<int> criarEvento({
    required SupabaseCadastroEventoModel dadosEvento,
    required String organizadorId,
    Uint8List? imagemSelecionada,
  }) async {
    try {
      final eventoCriado = await _eventoService.insertEvento(dadosEvento.toMapSemId());
      final eventoId = eventoCriado['id'] as int;

      if (imagemSelecionada != null){
        final url = await _storageService.uploadCapaEvento(
          organizadorId: organizadorId,
          eventoId: eventoId,
          bytes: imagemSelecionada
        );
        await _eventoService.updateImagemCapa(eventoId, url);
      }
      return eventoId;
    } catch (ex, stackTrace) {
      developer.log(
          'Falha ao criar evento - Exception',
          name: 'EventoRepository',
          error: ex,
          stackTrace: stackTrace
      );
      throw EventoFailure("Não foi possível criar o evento. Tente novamente.");
    }
  }

  Future<void> editarEvento({
    required int eventoId,
    required SupabaseCadastroEventoModel dadosEvento,
    required String organizadorId,
    XFile? novaImagem
  }) async {
    try{
      if (novaImagem != null) {
        final bytes = await novaImagem.readAsBytes();
        final url = await _storageService.uploadCapaEvento(
          organizadorId: organizadorId,
          eventoId: eventoId,
          bytes: bytes
        );
        await _eventoService.updateImagemCapa(eventoId, url);
      }

      await _eventoService.updateEvento(eventoId, dadosEvento.toMap());
    } catch (ex, stackTrace) {
      developer.log(
          'Falha ao editar evento - Exception',
          name: 'EventoRepository',
          error: ex,
          stackTrace: stackTrace
      );
      throw EventoFailure("Não foi possível editar o evento. Tente novamente.");
    }
  }
}