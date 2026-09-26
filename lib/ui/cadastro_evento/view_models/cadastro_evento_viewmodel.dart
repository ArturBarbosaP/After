import 'dart:typed_data';
import 'package:after_project/data/model/supabase_cadastro_evento_model.dart';
import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/domain/models/evento.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class CadastroEventoViewmodel extends ChangeNotifier {
  final EventoRepository _eventoRepository;
  final UserRepository _userRepository;
  final int id;

  CadastroEventoViewmodel(this._eventoRepository, this._userRepository, this.id){
    _edicao = id != 0;
    if (_edicao){
      _loadEvento();
    }
  }

  bool _screenLoading = false;
  bool get screenLoading => _screenLoading;

  bool _loading = false;
  bool get isLoading => _loading;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  bool _edicao = false;
  bool get edicao => _edicao;

  Evento? _evento;
  Evento? get evento => _evento;

  void limparErro(){
    _mensagemErro = null;
    notifyListeners();
  }

  Future<void> _loadEvento() async {
    _screenLoading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final organizador = await _userRepository.getOrganizadorAtual();
      if (organizador == null){
        _mensagemErro = 'Usuário logado não é organizador';
        _screenLoading = false;
        notifyListeners();
        return;
      }
      _evento = await _eventoRepository.getEventoOrganizadorPorId(organizador.id, id);
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
      _screenLoading = false;
      notifyListeners();
    }
  }

  Future<bool> cadastro(SupabaseCadastroEventoModel model, Uint8List? imagemSelecionada) async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final organizador = await _userRepository.getOrganizadorAtual();
      model.organizadorId = organizador!.id;

      await _eventoRepository.criarEvento(
        dadosEvento: model,
        organizadorId: model.organizadorId,
        imagemSelecionada: imagemSelecionada
      );

      _loading = false;
      notifyListeners();
      return true;
    } on EventoFailure catch (e) {
      _mensagemErro = e.message;
      _loading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
        'Falha ao cadastrar evento',
        name: 'CadastroEventoViewmodel',
        error: e,
        stackTrace: stackTrace
      );
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> editar(SupabaseCadastroEventoModel model, Uint8List? imagemSelecionada) async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final organizador = await _userRepository.getOrganizadorAtual();
      model.organizadorId = organizador!.id;
      model.id = id;

      await _eventoRepository.editarEvento(
        dadosEvento: model,
        eventoId: id,
        organizadorId: model.organizadorId,
        novaImagem: imagemSelecionada
      );

      _loading = false;
      notifyListeners();
      return true;
    } on EventoFailure catch (e) {
      _mensagemErro = e.message;
      _loading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
        'Falha ao editar evento',
        name: 'CadastroEventoViewmodel',
        error: e,
        stackTrace: stackTrace
      );
      _loading = false;
      notifyListeners();
      return false;
    }
  }
}