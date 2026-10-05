import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/domain/models/evento_detalhado.dart';
import 'package:after_project/domain/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class DetalheEventoViewmodel extends ChangeNotifier {
  final EventoRepository _eventoRepository;
  final UserRepository _userRepository;
  final int id;

  DetalheEventoViewmodel(this._eventoRepository, this._userRepository, this.id){
    _loadEvento();
    _loadUsuarioEvento();
  }

  bool _loading = false;
  bool get isLoading => _loading;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  EventoDetalhado? _evento;
  EventoDetalhado? get evento => _evento;

  List<UserProfile> _amigosPresentes = [];
  List<UserProfile> get amigosPresentes => _amigosPresentes;

  bool _favorito = false;
  bool get favorito => _favorito;

  bool _presenca = false;
  bool get presenca => _presenca;

  bool _podeEditar = false;
  bool get podeEditar => _podeEditar;

  bool _logado = false;
  bool get usuarioLogado => _logado;

  Future<void> _loadEvento() async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      _evento = await _eventoRepository.getEventoPorId(id);
      _amigosPresentes = await _eventoRepository.getAmigosPresentes(id);
      _podeEditar = await getPodeEditar();

      _loading = false;
    } on EventoFailure catch (e) {
      _mensagemErro = e.message;
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
        'Falha ao recuperar evento pelo id',
        name: 'DetalheEventoViewmodel',
        error: e,
        stackTrace: stackTrace
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> _loadUsuarioEvento() async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final user = await _userRepository.getUsuarioAtual();
      if (user == null){
        _logado = false;
        return;
      }
      _logado = true;

      final status = await _eventoRepository.getStatusUsuarioEvento(user.id, id);

      _favorito = status.favorito;
      _presenca = status.presenca;

      _loading = false;
    } on EventoFailure catch (e) {
      _mensagemErro = e.message;
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
        'Falha ao recuperar usuario evento',
        name: 'DetalheEventoViewmodel',
        error: e,
        stackTrace: stackTrace
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> toggleFavorito() async {
    _mensagemErro = null;
    final novoValor = !_favorito;
    _favorito = novoValor;
    notifyListeners();

    try {
      final user = await _userRepository.getUsuarioAtual();
      if (user == null) return;

      await _eventoRepository.setFavorito(user.id, id, novoValor);
    } on EventoFailure catch (e) {
      _favorito = !novoValor;
      _mensagemErro = e.message;
    } catch (e, stackTrace) {
      _favorito = !novoValor;
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
        'Falha ao favoritar evento',
        name: 'DetalheEventoViewmodel',
        error: e,
        stackTrace: stackTrace
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> togglePresenca() async {
    _mensagemErro = null;
    final novoValor = !_presenca;
    _presenca = novoValor;
    notifyListeners();

    try {
      final user = await _userRepository.getUsuarioAtual();
      if (user == null) return;

      await _eventoRepository.setPresenca(user.id, id, novoValor);
    } on EventoFailure catch (e) {
      _presenca = !novoValor;
      _mensagemErro = e.message;
    } catch (e, stackTrace) {
      _presenca = !novoValor;
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
        'Falha ao marcar presença no evento',
        name: 'DetalheEventoViewmodel',
        error: e,
        stackTrace: stackTrace
      );
    } finally {
      notifyListeners();
    }
  }

  Future<bool> getPodeEditar() async {
    final organizador = await _userRepository.getOrganizadorAtual();
    return organizador != null && evento?.organizadorId == organizador.id;
  }
}