import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/domain/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class EdicaoUsuarioViewmodel extends ChangeNotifier {
  final UserRepository _userRepository;

  EdicaoUsuarioViewmodel(this._userRepository){
    _load();
  }

  bool _loading = false;
  bool get isLoading => _loading;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  UserProfile? _usuario;
  UserProfile? get usuario => _usuario;

  bool _isOrganizador = false;
  bool get isOrganizador => _isOrganizador;

  Future<void> _load() async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      _usuario = await _userRepository.getUsuarioAtual();
      if (_usuario == null) {
        _mensagemErro = 'Faça login para ver o seu perfil.';
      }
      _isOrganizador = await _userRepository.getOrganizadorAtual() != null;
    } on UserFailure catch (e) {
      _mensagemErro = e.message;
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
        'Falha ao carregar perfil',
        name: 'PerfilViewmodel',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}