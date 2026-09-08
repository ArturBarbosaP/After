import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/domain/enums/categoria_enum.dart';
import 'package:after_project/domain/models/evento_detalhado.dart';
import 'package:after_project/domain/models/user_profile.dart';
import 'package:after_project/ui/home/view_models/eventos_com_amigos.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer' as developer;

class HomeViewmodel extends ChangeNotifier {
  final UserRepository _userRepository;
  final EventoRepository _eventoRepository;

  HomeViewmodel(this._userRepository, this._eventoRepository){
    _loadUsuario();
    _loadEventoDestaque();
    _loadEventosAoVivo();
  }

  bool _loading = false;
  bool get isLoading => _loading;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  UserProfile? _usuario;
  UserProfile? get usuario => _usuario;

  EventoDetalhado? _eventoDetalhado;
  EventoDetalhado? get eventoDestaque => _eventoDetalhado;

  Categoria? _categoriaSelecionadaFiltro;
  Categoria? get categoriaSelecionadaFiltro => _categoriaSelecionadaFiltro;

  List<EventosComAmigos> _eventosAoVivo = [];
  List<EventosComAmigos> get eventosAoVivo => _eventosAoVivo;

  Future<void> _loadUsuario() async {
    try {
      _usuario = await _userRepository.getUsuarioAtual();
      notifyListeners();
    } on UserFailure catch (e) {
      _mensagemErro = e.message;
      notifyListeners();
    } catch (e, stackTrace) {
      _loading = false;
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      notifyListeners();
      developer.log(
          'Falha ao recuperar usuário',
          name: 'HomeViewmodel',
          error: e,
          stackTrace: stackTrace
      );
    }
  }

  Future<void> _loadEventoDestaque() async {
    try {
      _eventoDetalhado = await _eventoRepository.getEventoDestaque();
      notifyListeners();
    } on EventoFailure catch (e) {
      _mensagemErro = e.message;
      notifyListeners();
    } catch (e, stackTrace) {
      _loading = false;
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      notifyListeners();
      developer.log(
          'Falha ao recuperar evento destaque',
          name: 'HomeViewmodel',
          error: e,
          stackTrace: stackTrace
      );
    }
  }

  Future<void> _loadEventosAoVivo() async {
    try {
      final eventos = await _eventoRepository.getEventosAoVivo();

      final comAmigos = await Future.wait(
        eventos.map((evento) async {
          final amigos = await _eventoRepository.getAmigosPresentes(evento.id);
          return EventosComAmigos(evento: evento, amigosPresentes: amigos);
        }),
      );
      _eventosAoVivo = comAmigos;
      notifyListeners();
    } on EventoFailure catch (e) {
      _mensagemErro = e.message;
      notifyListeners();
    } catch (e, stackTrace) {
      _loading = false;
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      notifyListeners();
      developer.log(
          'Falha ao recuperar eventos ao vivo com amigos',
          name: 'HomeViewmodel',
          error: e,
          stackTrace: stackTrace
      );
    }
  }

  void filtrarCategoria(Categoria? categoria) async {
    _categoriaSelecionadaFiltro = categoria;
    notifyListeners();
    //TODO filtrar eventos pela categoria selecionada
  }
}