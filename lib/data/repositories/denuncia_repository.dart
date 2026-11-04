import 'package:after_project/data/model/supabase_denuncia_model.dart';
import 'package:after_project/data/services/supabase_denuncia_service.dart';
import 'dart:developer' as developer;

class DenunciaFailure implements Exception {
  final String message;
  DenunciaFailure(this.message);
}

class DenunciaRepository {
  final SupabaseDenunciaService _denunciaService;

  DenunciaRepository(this._denunciaService);

  Future<void> criarDenuncia({required SupabaseDenunciaModel dadosDenuncia}) async {
    try {
      await _denunciaService.insertDenuncia(dadosDenuncia.toMap());
    } catch (ex, stackTrace) {
      developer.log(
        'Falha ao criar denuncia - Exception',
        name: 'DenunciaRepository',
        error: ex,
        stackTrace: stackTrace
      );
      throw DenunciaFailure("Não foi possível criar a denúncia. Tente novamente.");
    }
  }
}