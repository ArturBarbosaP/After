import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/domain/models/user_profile.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer' as developer;

class HomeViewmodel extends ChangeNotifier {
  final UserRepository _userRepository;

  HomeViewmodel(this._userRepository){
    _loadUsuario();
  }

  UserProfile? _usuario;
  UserProfile? get usuario => _usuario;

  bool _loading = false;
  bool get isLoading => _loading;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

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
}