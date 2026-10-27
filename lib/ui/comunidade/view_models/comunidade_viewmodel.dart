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

  // Erro de carregamento ou de login (aparece no lugar do chat).
  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  // Erro de envio (aparece em um SnackBar, o chat continua na tela).
  String? _erroEnvio;
  String? get erroEnvio => _erroEnvio;

  bool _enviando = false;
  bool get isEnviando => _enviando;

  late UserProfile _usuarioAtual;
  UserProfile get usuarioAtual => _usuarioAtual;

  List<MensagemComunidade> _mensagens = [];
  List<MensagemComunidade> get mensagens => _mensagens;

  bool _logado = false;
  bool get usuarioLogado => _logado;

  // O chat só aparece se está logado e carregou sem erro.
  bool get chatDisponivel => _logado && _mensagemErro == null;

  Future<void> _load() async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final user = await _userRepository.getUsuarioAtual();
      if (user == null) {
        _mensagemErro = 'Você precisa fazer login para ver a comunidade do evento.';
        _logado = false;
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
        },
      );
    } on UserFailure catch (e) {
      _mensagemErro = e.message;
    } on ComunidadeFailure catch (e) {
      _mensagemErro = e.message;
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

  /// Retorna true se enviou (ou se não havia nada para enviar).
  Future<bool> enviarMensagem(String texto) async {
    final limpo = texto.trim();
    if (limpo.isEmpty) return true;

    _enviando = true;
    _erroEnvio = null;
    notifyListeners();

    try {
      await _mensagemRepository.enviarMensagem(
        eventoId: eventoId,
        mensagem: MensagemComunidadeDto(
          id: '',
          autorId: _usuarioAtual.id,
          autorNome: _usuarioAtual.nome,
          autorUrlFoto: _usuarioAtual.urlFotoPerfil,
          texto: limpo,
          enviadaEm: DateTime.now().toIso8601String(),
        ),
      );
      return true;
    } on ComunidadeFailure catch (e) {
      _erroEnvio = e.message;
      return false;
    } catch (e, stackTrace) {
      _erroEnvio = 'Erro ao enviar mensagem.';
      developer.log(
        'Falha ao enviar mensagem',
        name: 'ComunidadeViewmodel',
        error: e,
        stackTrace: stackTrace,
      );
      return false;
    } finally {
      _enviando = false;
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