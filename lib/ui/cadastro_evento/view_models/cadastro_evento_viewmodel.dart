import 'package:after_project/data/model/supabase_cadastro_evento_model.dart';
import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/domain/models/evento_detalhado.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class CadastroEventoViewmodel extends ChangeNotifier {
  final EventoRepository _eventoRepository;
  final int id;

  CadastroEventoViewmodel(this._eventoRepository, this.id){
    _edicao = id != 0;
    if (_edicao){
      _loadEvento();
    }
  }

  bool _loading = false;
  bool get isLoading => _loading;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  bool _edicao = false;
  bool get edicao => _edicao;

  EventoDetalhado? _evento;
  EventoDetalhado? get evento => _evento;

  void limparErro(){
    _mensagemErro = null;
    notifyListeners();
  }

  Future<void> _loadEvento() async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      _evento = await _eventoRepository.getEventoPorId(id);
    } on EventoFailure catch (e) {
      _mensagemErro = e.message;
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
          'Falha ao recuperar evento pelo id',
          name: 'CadastroEventoViewmodel',
          error: e,
          stackTrace: stackTrace
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> cadastro(SupabaseCadastroEventoModel model) async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    return true;
  }
}