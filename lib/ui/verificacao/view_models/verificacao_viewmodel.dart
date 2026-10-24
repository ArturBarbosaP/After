import 'package:after_project/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class VerificacaoViewmodel extends ChangeNotifier {
  final UserRepository _userRepository;

  VerificacaoViewmodel(this._userRepository){
    _load();
  }

  bool _loading = false;
  bool get isLoading => _loading;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  bool _isOrganizador = false;
  bool get isOrganizador => _isOrganizador;

  Future<void> _load() async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final organizador = await _userRepository.getOrganizadorAtual();
      _isOrganizador = organizador != null;
    } on UserFailure catch (e) {
      _mensagemErro = e.message;
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
        'Falha ao recuperar usuário',
        name: 'VerificacaoViewmodel',
        error: e,
        stackTrace: stackTrace
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> verificar(String documento, DateTime? dataNascimento) async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final usuario = await _userRepository.getUsuarioAtual();
      final id = usuario!.id;

      final response = await _userRepository.verificar(
        id: id,
        isOrganizador: _isOrganizador,
        documento: documento,
        dataNascimento: dataNascimento
      );

      _mensagemErro = response.mensagem;
      _loading = false;
      notifyListeners();
      return response.ok;
    } on UserFailure catch (e) {
      _mensagemErro = e.message;
      _loading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      _loading = false;
      notifyListeners();
      developer.log(
        'Falha ao verificar usuário',
        name: 'VerificacaoViewmodel',
        error: e,
        stackTrace: stackTrace
      );
      return false;
    }
  }

  void limparErro(){
    _mensagemErro = null;
    notifyListeners();
  }
}