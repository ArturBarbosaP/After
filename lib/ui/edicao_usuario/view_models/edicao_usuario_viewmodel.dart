import 'dart:typed_data';
import 'package:after_project/data/model/supabase_edicao_usuario_model.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/domain/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class EdicaoUsuarioViewmodel extends ChangeNotifier {
  final UserRepository _userRepository;

  EdicaoUsuarioViewmodel(this._userRepository){
    _load();
  }

  bool _screenLoading = false;
  bool get screenLoading => _screenLoading;

  bool _loading = false;
  bool get isLoading => _loading;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  UserProfile? _usuario;
  UserProfile? get usuario => _usuario;

  bool _isOrganizador = false;
  bool get isOrganizador => _isOrganizador;

  void limparErro(){
    _mensagemErro = null;
    notifyListeners();
  }

  Future<void> _load() async {
    _screenLoading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      _usuario = await _userRepository.getUsuarioAtual();
      if (_usuario == null) {
        _mensagemErro = 'Faça login para ver o seu perfil.';
      }
      final organizador = await _userRepository.getOrganizadorAtual();
      _isOrganizador = organizador != null;

      if (_isOrganizador){
        _usuario!.site = organizador!.site;
      }

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
      _screenLoading = false;
      notifyListeners();
    }
  }

  Future<bool> editar(SupabaseEdicaoUsuarioModel model, Uint8List? imagemSelecionada) async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      model.id = usuario!.id;

      await _userRepository.editar(
        id: usuario!.id,
        model: model,
        organizador: _isOrganizador,
        novaImagem: imagemSelecionada
      );

      _loading = false;
      notifyListeners();
      return true;
    } on UserFailure catch (e) {
      _mensagemErro = e.message;
      _loading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
        'Falha ao editar perfil',
        name: 'EdicaoUsuarioViewmodel',
        error: e,
        stackTrace: stackTrace
      );
      _loading = false;
      notifyListeners();
      return false;
    }
  }
}