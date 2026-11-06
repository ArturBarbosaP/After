import 'package:after_project/data/model/mensagem_comunidade_dto.dart';
import 'package:after_project/data/services/supabase_mensagem_service.dart';
import 'package:after_project/domain/models/mensagem_comunidade.dart';
import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';

class ComunidadeFailure implements Exception {
  final String message;
  ComunidadeFailure(this.message);
}

class MensagemRepository {
  final SupabaseMensagemService _mensagemService;

  MensagemRepository(this._mensagemService);

  Future<List<MensagemComunidade>> getMensagens(int eventoId) async {
    try {
      final rows = await _mensagemService.fetchMensagens(eventoId);
      return rows.map((json) => MensagemComunidadeDto.fromJson(json).toDomain()).toList();
    } catch (ex, stackTrace) {
      developer.log(
        'Falha ao buscar mensagens do evento - Exception',
        name: 'MensagemRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw ComunidadeFailure('Não foi possível carregar as mensagens.');
    }
  }

  Future<void> enviarMensagem({required MensagemComunidadeDto mensagem, required int eventoId}) async {
    try {
      await _mensagemService.enviarMensagem(mensagem.toMap(eventoId));
    } catch (ex, stackTrace) {
      developer.log(
        'Falha ao enviar mensagem - Exception',
        name: 'MensagemRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw ComunidadeFailure('Não foi possível enviar sua mensagem.');
    }
  }

  RealtimeChannel escutarMensagens({
    required int eventoId,
    required void Function(MensagemComunidade mensagem) onNovaMensagem,
    required void Function(MensagemComunidade mensagem) onMensagemAtualizada,
  }) {
    try {
      return _mensagemService.escutarMensagens(
        eventoId: eventoId,
        onNovaMensagem: (json) => onNovaMensagem(MensagemComunidadeDto.fromJson(json).toDomain()),
        onMensagemAtualizada: (json) => onMensagemAtualizada(MensagemComunidadeDto.fromJson(json).toDomain()),
      );
    } catch (ex, stackTrace) {
      developer.log(
        'Falha ao escutar mensagens - Exception',
        name: 'MensagemRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw ComunidadeFailure('Não foi possível entrar no canal.');
    }
  }

  Future<void> removerMensagem(String mensagemId) async {
    try {
      await _mensagemService.removerMensagem(mensagemId);
    } catch (ex, stackTrace) {
      developer.log(
        'Falha ao remover mensagem - Exception',
        name: 'MensagemRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw ComunidadeFailure('Não foi possível remover a mensagem.');
    }
  }

  Future<void> pararDeEscutar(RealtimeChannel channel) {
    try {
      return _mensagemService.pararDeEscutar(channel);
    } catch (ex, stackTrace) {
      developer.log(
        'Falha ao parar de escutar as mensagens - Exception',
        name: 'MensagemRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw ComunidadeFailure('Não foi possível sair do canal.');
    }
  }
}