import 'package:after_project/data/model/supabase_denuncia_model.dart';
import 'package:after_project/data/repositories/denuncia_repository.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class DenunciaViewmodel extends ChangeNotifier {
  final int? eventoId;
  final String? usuarioId;
  final DenunciaRepository _denunciaRepository;

  DenunciaViewmodel(this._denunciaRepository, this.eventoId, this.usuarioId);

  bool _loading = false;
  bool get isLoading => _loading;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  Future<bool> enviarDenuncia(String descricao) async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      await _denunciaRepository.criarDenuncia(
        dadosDenuncia: SupabaseDenunciaModel(
          criadoEm: DateTime.now().toIso8601String(),
          usuarioId: usuarioId,
          eventoId: eventoId,
          descricao: descricao
        )
      );

      _loading = false;
      notifyListeners();
      return true;
    } on DenunciaFailure catch (e) {
      _mensagemErro = e.message;
      _loading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
        'Falha ao criar denúncia',
        name: 'DenunciaViewmodel',
        error: e,
        stackTrace: stackTrace,
      );
      _loading = false;
      notifyListeners();
      return false;
    }
  }
}