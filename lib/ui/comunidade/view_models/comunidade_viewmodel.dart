import 'dart:developer' as developer;
import 'package:after_project/data/model/mensagem_comunidade_dto.dart';
import 'package:after_project/data/repositories/mensagem_repository.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/domain/models/mensagem_comunidade.dart';
import 'package:after_project/domain/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
 
class ComunidadeViewmodel extends ChangeNotifier {
  final UserRepository _userRepository;
  final MensagemRepository _mensagemRepository;
  final int eventoId;
 
  ComunidadeViewmodel(this._userRepository, this._mensagemRepository, this.eventoId) {
    _load();
  }

  RealtimeChannel? _channel;

  bool _loading = false;
  bool get isLoading => _loading;
 
  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;
 
  late UserProfile _usuarioAtual;
  UserProfile get usuarioAtual => _usuarioAtual;
 
  List<MensagemComunidade> _mensagens = [];
  List<MensagemComunidade> get mensagens => _mensagens;

  bool _logado = false;
  bool get usuarioLogado => _logado;
 
  Future<void> _load() async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();
 
    try {
      final user = await _userRepository.getUsuarioAtual();
      if (user == null){
        _mensagemErro = 'Você precisa fazer login para ver a comunidade do evento.';
        _loading = false;
        _logado = false;
        notifyListeners();
        return;
      }
      _logado = true;
      _usuarioAtual = user;

      _mensagens = await _mensagemRepository.getMensagens(eventoId);

      _channel = _mensagemRepository.escutarMensagens(
        eventoId: eventoId,
        onNovaMensagem: (mensagem) {
          final jaExiste = _mensagens.any((m) => m.id == mensagem.id);
          if (jaExiste) return;
          _mensagens = [..._mensagens, mensagem];
          notifyListeners();
        }
      );
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
      await _mensagemRepository.enviarMensagem(
        eventoId: eventoId,
        mensagem: MensagemComunidadeDto(
          id: '',
          autorId: _usuarioAtual.id,
          autorNome: _usuarioAtual.nome,
          autorUrlFoto: _usuarioAtual.urlFotoPerfil,
          texto: texto,
          enviadaEm: DateTime.now().toIso8601String(),
        )
      );
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

  @override
  void dispose() {
    if (_channel != null) {
      _mensagemRepository.pararDeEscutar(_channel!);
    }
    super.dispose();
  }
}
 