import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/domain/models/evento_detalhado.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class DetalheEventoViewmodel extends ChangeNotifier {
  final EventoRepository _eventoRepository;

  DetalheEventoViewmodel(this._eventoRepository){
    _loadEvento();
  }


  late EventoDetalhado _evento;
  EventoDetalhado get evento => _evento;

  Future<void> _loadEvento() async {
    try {
      _evento = (await _eventoRepository.getEventoDestaque())!; //TODO pegar evento clicado
      notifyListeners();
    } on EventoFailure catch (e) {
      notifyListeners();
    } catch (e, stackTrace) {
      notifyListeners();
      developer.log(
          'Falha ao recuperar evento destaque',
          name: 'HomeViewmodel',
          error: e,
          stackTrace: stackTrace
      );
    }
  }

}