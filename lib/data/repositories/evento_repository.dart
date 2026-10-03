import 'dart:typed_data';
import 'package:after_project/data/model/evento_detalhado_dto.dart';
import 'package:after_project/data/model/evento_dto.dart';
import 'package:after_project/data/model/evento_mapa_dto.dart';
import 'package:after_project/data/model/supabase_cadastro_evento_model.dart';
import 'package:after_project/data/services/supabase_evento_service.dart';
import 'package:after_project/data/services/supabase_storage_service.dart';
import 'package:after_project/domain/enums/categoria_enum.dart';
import 'package:after_project/domain/models/evento.dart';
import 'package:after_project/domain/models/evento_detalhado.dart';
import 'package:after_project/domain/models/evento_mapa.dart';
import 'package:after_project/domain/models/user_profile.dart';
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

  Future<List<EventoDetalhado>> getEventosAoVivo(Categoria? categoria) async {
    try{
      final rows = categoria != null
          ? await _eventoService.fetchEventosAoVivoPelaCategoria(categoria)
          : await _eventoService.fetchEventosAoVivo();
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

  Future<List<EventoDetalhado>> getEventosAoVivoPorTitulo(Categoria? categoria, String titulo) async {
    try{
      final rows = categoria != null
          ? await _eventoService.fetchEventosAoVivoPelaCategoriaETitulo(categoria, titulo)
          : await _eventoService.fetchEventosAoVivoPorTitulo(titulo);
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

  Future<List<EventoDetalhado>> getProximosEventos(Categoria? categoria) async {
    try {
      final rows = categoria != null
          ? await _eventoService.fetchProximosEventosPelaCategoria(categoria)
          : await _eventoService.fetchProximosEventos();

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

  Future<List<EventoDetalhado>> getProximosEventosPorTitulo(Categoria? categoria, String titulo) async {
    try {
      final rows = categoria != null
          ? await _eventoService.fetchProximosEventosPelaCategoriaETitulo(categoria, titulo)
          : await _eventoService.fetchProximosEventosPorTitulo(titulo);

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

  Future<Evento?> getEventoOrganizadorPorId(String organizadorId, int eventoId) async {
    try {
      final json = await _eventoService.fetchEventoOrganizadorPorId(organizadorId, eventoId);
      if (json == null) return null;

      return EventoDto.fromJson(json).toDomain();
    } catch (ex, stackTrace) {
      developer.log(
        'Falha ao recuperar evento do organizador pelo id - Exception',
        name: 'EventoRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw EventoFailure("Não foi possível recuperar o evento do organizador pelo id. Tente novamente.");
    }
  }

  Future<List<Evento>> getPesquisarMeusEventosOrganizador(String organizadorId, String titulo) async {
    try {
      final rows = await _eventoService.fetchPesquisarMeusEventosOrganizador(organizadorId, titulo);
      return rows.map((json) => EventoDto.fromJson(json).toDomain()).toList();
    } catch (ex, stackTrace) {
      developer.log(
        'Falha ao pesquisar eventos do organizador - Exception',
        name: 'EventoRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw EventoFailure("Não foi possível recuperar os eventos pesquisados. Tente novamente.");
    }
  }

  Future<List<EventoMapa>> getEventosAoVivoMapa() async {
    try {
      final rows = await _eventoService.fetchEventosAoVivoMapa();
      return rows.map((json) => EventoMapaDto.fromJson(json).toDomain()).toList();
    } catch (ex, stackTrace) {
      developer.log(
        'Falha ao buscar eventos ao vivo para o mapa - Exception',
        name: 'EventoRepository',
        error: ex,
        stackTrace: stackTrace,
      );
      throw EventoFailure('Não foi possível carregar os eventos no mapa. Tente novamente.');
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
    Uint8List? novaImagem
  }) async {
    try {
      await _eventoService.updateEvento(eventoId, dadosEvento.toMap());

      if (novaImagem != null) {
        final url = await _storageService.uploadCapaEvento(
          organizadorId: organizadorId,
          eventoId: eventoId,
          bytes: novaImagem
        );
        await _eventoService.updateImagemCapa(eventoId, url);
      }
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