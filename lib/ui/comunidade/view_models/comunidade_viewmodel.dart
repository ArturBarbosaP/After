import 'dart:developer' as developer;
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/domain/models/mensagem_comunidade.dart';
import 'package:flutter/material.dart';
 
class ComunidadeViewmodel extends ChangeNotifier {
  final UserRepository _userRepository;
  final int eventoId;
 
  ComunidadeViewmodel(this._userRepository, this.eventoId) {
    _load();
  }
 
  bool _loading = false;
  bool get isLoading => _loading;
 
  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;
 
  int? _usuarioAtualId;
  int? get usuarioAtualId => _usuarioAtualId;
 
  List<MensagemComunidade> _mensagens = [];
  List<MensagemComunidade> get mensagens => _mensagens;
 
  Future<void> _load() async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();
 
    try {
      final user = await _userRepository.getUsuarioAtual();
      _usuarioAtualId = user?.id;
      // TODO buscar mensagens do evento no repository (e depois ouvir em tempo real)
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
        'Falha ao carregar comunidade',
        name: 'ComunidadeViewmodel',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
 
  Future<void> enviarMensagem(String texto) async {
    final limpo = texto.trim();
    if (limpo.isEmpty) return;
 
    try {
      final user = await _userRepository.getUsuarioAtual();
      if (user == null) return;
 
      // TODO trocar por chamada ao repository; por enquanto fica só em memória
      _mensagens = [
        ..._mensagens,
        MensagemComunidade(
          id: DateTime.now().millisecondsSinceEpoch,
          autorId: user.id,
          autorNome: user.nome,
          autorUrlFoto: user.urlFotoPerfil,
          texto: limpo,
          enviadaEm: DateTime.now(),
        ),
      ];
      notifyListeners();
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro ao enviar mensagem.';
      developer.log(
        'Falha ao enviar mensagem',
        name: 'ComunidadeViewmodel',
        error: e,
        stackTrace: stackTrace,
      );
      notifyListeners();
    }
  }
}
 