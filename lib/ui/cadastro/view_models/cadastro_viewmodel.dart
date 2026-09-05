import 'package:after_project/data/model/supabase_cadastro_model.dart';
import 'package:after_project/data/repositories/auth_repository.dart';
import 'package:flutter/cupertino.dart';

class CadastroViewmodel extends ChangeNotifier {
  final AuthRepository _authRepository;

  CadastroViewmodel(this._authRepository);

  bool _loading = false;
  bool get isLoading => _loading;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  Future<bool> cadastro(SupabaseCadastroModel model) async {
    _loading = true;
    _mensagemErro = null;

    notifyListeners();

    try {
      await _authRepository.cadastro(model: model);
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
    }
  }
}