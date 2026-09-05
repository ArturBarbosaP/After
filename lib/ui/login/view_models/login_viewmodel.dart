import 'package:after_project/data/repositories/auth_repository.dart';
import 'package:flutter/cupertino.dart';
import 'dart:developer' as developer;

class LoginViewmodel extends ChangeNotifier {
  final AuthRepository _authRepository;

  LoginViewmodel(this._authRepository);

  bool _loading = false;
  bool get isLoading => _loading;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  void limparErro(){
    _mensagemErro = null;
    notifyListeners();
  }

  Future<bool> loginEmailSenha({required String email, required String senha}) async {
    _loading = true;
    _mensagemErro = null;

    notifyListeners();

    try {
      await _authRepository.login(email: email, senha: senha);
      _loading = false;
      notifyListeners();
      return true;
    } on AuthFailure catch (e) {
      _loading = false;
      _mensagemErro = e.message;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _loading = false;
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      notifyListeners();
      developer.log(
          'Falha no login com email e senha',
          name: 'LoginViewmodel',
          error: e,
          stackTrace: stackTrace
      );
      return false;
    }
  }

  Future<bool> loginGoogle() async {
    _loading = true;
    _mensagemErro = null;

    notifyListeners();

    try {
      await _authRepository.loginGoogle();
      _loading = false;
      notifyListeners();
      return true;
    } on AuthFailure catch (e) {
      _loading = false;
      _mensagemErro = e.message;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _loading = false;
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      notifyListeners();
      developer.log(
          'Falha no login google',
          name: 'LoginViewmodel',
          error: e,
          stackTrace: stackTrace
      );
      return false;
    }
  }
}