import 'package:after_project/data/repositories/user_repository.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class ShellViewmodel extends ChangeNotifier {
  final UserRepository _userRepository;

  ShellViewmodel(this._userRepository){
    _loadIsOrganizador();
  }

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  bool _isOrganizador = false;
  bool get isOrganizador => _isOrganizador;

  Future<void> _loadIsOrganizador() async {
    try {
      _isOrganizador = await _userRepository.getOrganizadorAtual() != null;
      notifyListeners();
    } on UserFailure catch (e) {
      _mensagemErro = e.message;
      notifyListeners();
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
          'Falha ao recuperar organizador',
          name: 'ShellViewmodel',
          error: e,
          stackTrace: stackTrace
      );
    }
  }

}