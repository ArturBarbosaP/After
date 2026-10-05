import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/domain/models/evento.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class EventosFavoritosViewmodel extends ChangeNotifier {
  final EventoRepository _eventoRepository;
  final UserRepository _userRepository;

  EventosFavoritosViewmodel(this._eventoRepository, this._userRepository){
    _loadEventos();
  }

  bool _loading = false;
  bool get isLoading => _loading;

  bool _logado = true;
  bool get usuarioLogado => _logado;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  List<Evento> _eventosOriginais = [];
  List<Evento> _eventos = [];
  List<Evento> get eventos => _eventos;

  String _termo = '';

  Future<void> _loadEventos() async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final usuario = await _userRepository.getUsuarioAtual();
      if (usuario == null){
        _mensagemErro = 'Você precisa fazer login para ver os eventos favoritados.';
        _loading = false;
        _logado = false;
        notifyListeners();
        return;
      }
      _logado = true;

      final eventos = await _eventoRepository.getEventosFavoritos(usuario.id);
      _eventos = eventos;
      _eventosOriginais = eventos;
    } on EventoFailure catch (e) {
      _mensagemErro = e.message;
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
        'Falha ao recuperar eventos favoritos do usuário',
        name: 'EventosFavoritosViewmodel',
        error: e,
        stackTrace: stackTrace
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> pesquisar(String titulo) async {
    final termo = titulo.trimRight();
    _termo = termo;

    if (termo.isEmpty) {
      _eventos = List.from(_eventosOriginais);
      _mensagemErro = null;
      notifyListeners();
      return;
    }

    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final usuario = await _userRepository.getUsuarioAtual();
      if (usuario == null){
        _mensagemErro = 'Você precisa fazer login para ver os eventos favoritados.';
        _loading = false;
        notifyListeners();
        return;
      }
      _eventos = await _eventoRepository.getEventosFavoritos(usuario.id, titulo: termo);
    } on EventoFailure catch (e) {
      _mensagemErro = e.message;
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
        'Falha ao pesquisar eventos favoritos do usuario',
        name: 'EventosFavoritosViewmodel',
        error: e,
        stackTrace: stackTrace
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await Future.wait([
      _loadEventos(),
      if (_termo.isNotEmpty)
        pesquisar(_termo),
    ]);
  }
}