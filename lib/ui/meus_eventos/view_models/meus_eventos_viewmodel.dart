import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/domain/models/evento.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class MeusEventosViewmodel extends ChangeNotifier {
  final EventoRepository _eventoRepository;
  final UserRepository _userRepository;

  MeusEventosViewmodel(this._eventoRepository, this._userRepository){
    _loadEventos();
  }

  bool _loading = false;
  bool get isLoading => _loading;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  List<Evento> _eventos = [];
  List<Evento> get eventos => _eventos;

  Future<void> _loadEventos() async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final organizador = await _userRepository.getOrganizadorAtual();
      if (organizador == null){
        _mensagemErro = 'Usuário logado não é organizador';
        _loading = false;
        notifyListeners();
      }
      _eventos = await _eventoRepository.getMeusEventosOrganizador(organizador!.id);
    } on EventoFailure catch (e) {
      _mensagemErro = e.message;
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
          'Falha ao recuperar eventos do organizador',
          name: 'MeusEventosViewmodel',
          error: e,
          stackTrace: stackTrace
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}