import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/data/services/location_service.dart';
import 'package:after_project/domain/models/evento_detalhado.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class MapaViewmodel extends ChangeNotifier {
  final EventoRepository _eventoRepository;

  MapaViewmodel(this._eventoRepository){
    _loadEventoMaisProximo();
  }

  bool _loading = false;
  bool get isLoading => _loading;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

  EventoDetalhado? _eventoMaisProximo;
  EventoDetalhado? get eventoMaisProximo => _eventoMaisProximo;

  Future<void> _loadEventoMaisProximo() async {
    _loading = true;
    _mensagemErro = null;
    notifyListeners();

    try {
      final locationService = getIt<LocationService>();
      final permission = await locationService.requestPermission();

      if (permission != LocationPermissionResult.granted){
        return;
      }

      final pos = await locationService.getCurrentPosition();
      _eventoMaisProximo = await _eventoRepository.getEventoPerto(pos.latitude, pos.longitude);
    } on EventoFailure catch (e) {
      _mensagemErro = e.message;
    } catch (e, stackTrace) {
      _mensagemErro = 'Erro inesperado. Tente novamente.';
      developer.log(
          'Falha ao recuperar evento perto',
          name: 'MapaViewmodel',
          error: e,
          stackTrace: stackTrace
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}