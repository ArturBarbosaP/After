import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/domain/models/evento_detalhado.dart';
import 'package:after_project/domain/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class DetalheEventoViewmodel extends ChangeNotifier {
  final EventoRepository _eventoRepository;
  final int id;

  DetalheEventoViewmodel(this._eventoRepository, this.id){
    _loadEvento();
  }

  bool _loading = false;
  bool get isLoading => _loading;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  EventoDetalhado? _evento;
  EventoDetalhado? get evento => _evento;

  List<UserProfile> _amigosPresentes = [];
  List<UserProfile> get amigosPresentes => _amigosPresentes;

  Future<void> _loadEvento() async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      _evento = await _eventoRepository.getEventoPorId(id);
      _amigosPresentes = await _eventoRepository.getAmigosPresentes(id);
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
      _loading = false;
      notifyListeners();
    }
  }
}