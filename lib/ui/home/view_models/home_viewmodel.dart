import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/data/repositories/auth_repository.dart';
import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/data/services/location_service.dart';
import 'package:after_project/domain/enums/categoria_enum.dart';
import 'package:after_project/domain/enums/permissao_localizacao_enum.dart';
import 'package:after_project/domain/models/evento_detalhado.dart';
import 'package:after_project/domain/models/user_profile.dart';
import 'package:after_project/ui/home/view_models/eventos_com_amigos.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer' as developer;

class HomeViewmodel extends ChangeNotifier {
  final UserRepository _userRepository;
  final EventoRepository _eventoRepository;
  final AuthRepository _authRepository;

  HomeViewmodel(this._userRepository, this._eventoRepository, this._authRepository){
    _loadUsuario();
    _loadEventoDestaque();
    _loadEventosAoVivo();
    _loadProximosEventos();
  }

  bool _loading = false;
  bool get isLoading => _loading;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  UserProfile? _usuario;
  UserProfile? get usuario => _usuario;

  EventoDetalhado? _eventoDestaque;
  EventoDetalhado? get eventoDestaque => _eventoDestaque;

  Categoria? _categoriaSelecionadaFiltro;
  Categoria? get categoriaSelecionadaFiltro => _categoriaSelecionadaFiltro;

  List<EventosComAmigos> _eventosAoVivo = [];
  List<EventosComAmigos> get eventosAoVivo => _eventosAoVivo;

  List<EventoDetalhado> _proximosEventos = [];
  List<EventoDetalhado> get proximosEventos => _proximosEventos;

  Future<void> _loadUsuario() async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      _usuario = await _userRepository.getUsuarioAtual();
    } on UserFailure catch (e) {
      _mensagemErro = e.message;
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
        'Falha ao recuperar usuário',
        name: 'HomeViewmodel',
        error: e,
        stackTrace: stackTrace
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> _loadEventoDestaque() async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final locationService = getIt<LocationService>();
      final permission = await locationService.requestPermission();

      if (permission != PermissaoLocalizacao.granted){
        return;
      }

      final pos = await locationService.getCurrentPosition();
      _eventoDestaque = await _eventoRepository.getEventoDestaque(pos.latitude, pos.longitude);
    } on EventoFailure catch (e) {
      _mensagemErro = e.message;
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
        'Falha ao recuperar evento destaque',
        name: 'HomeViewmodel',
        error: e,
        stackTrace: stackTrace
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> _loadEventosAoVivo() async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final eventos = await _eventoRepository.getEventosAoVivo(_categoriaSelecionadaFiltro);

      final comAmigos = await Future.wait(
        eventos.map((evento) async {
          final amigos = await _eventoRepository.getAmigosPresentes(evento.id);
          return EventosComAmigos(evento: evento, amigosPresentes: amigos);
        }),
      );
      _eventosAoVivo = comAmigos;
    } on EventoFailure catch (e) {
      _mensagemErro = e.message;
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
        'Falha ao recuperar eventos ao vivo com amigos',
        name: 'HomeViewmodel',
        error: e,
        stackTrace: stackTrace
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> _loadProximosEventos() async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      _proximosEventos = await _eventoRepository.getProximosEventos(_categoriaSelecionadaFiltro);
    } on EventoFailure catch (e) {
      _mensagemErro = e.message;
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
        'Falha ao recuperar próximos eventos',
        name: 'HomeViewmodel',
        error: e,
        stackTrace: stackTrace
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void filtrarCategoria(Categoria? categoria) async {
    _categoriaSelecionadaFiltro = categoria;
    _loadEventosAoVivo();
    _loadProximosEventos();
    notifyListeners();
  }

  Future<bool> logout() async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      await _authRepository.logout();
      _loading = false;
      notifyListeners();
      return true;
    } on AuthFailure catch (e) {
      _loading = false;
      _mensagemErro = e.message;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _loading = false;
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      notifyListeners();
      developer.log(
        'Falha no logout',
        name: 'HomeViewmodel',
        error: e,
        stackTrace: stackTrace
      );
      return false;
    }
  }
}