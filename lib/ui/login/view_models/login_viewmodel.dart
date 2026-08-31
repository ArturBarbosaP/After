import 'package:after_project/data/repositories/auth_repository.dart';
import 'package:flutter/cupertino.dart';

class LoginViewmodel extends ChangeNotifier {
  final AuthRepository _authRepository;

  LoginViewmodel(this._authRepository);

  bool _loading = false;
  bool get isLoading => _loading;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

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
    }
  }
}