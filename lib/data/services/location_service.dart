import 'package:after_project/domain/enums/permissao_localizacao_enum.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<PermissaoLocalizacao> requestPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return PermissaoLocalizacao.serviceDisabled;
    }

    var permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      return PermissaoLocalizacao.denied;
    }

    if (permission == LocationPermission.deniedForever) {
      return PermissaoLocalizacao.deniedForever;
    }

    return PermissaoLocalizacao.granted;
  }

  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }
}