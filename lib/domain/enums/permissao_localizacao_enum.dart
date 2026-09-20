enum PermissaoLocalizacao {
  granted,
  serviceDisabled,   // GPS do aparelho está desligado
  denied,            // usuário negou, mas pode perguntar de novo
  deniedForever;      // usuário negou permanentemente (precisa ir nas configs do app)

  static PermissaoLocalizacao fromString(String value){
    switch (value) {
      case 'Granted':
        return PermissaoLocalizacao.granted;
      case 'serviceDisabled':
        return PermissaoLocalizacao.serviceDisabled;
      case 'denied':
        return PermissaoLocalizacao.denied;
      case 'deniedForever':
        return PermissaoLocalizacao.deniedForever;
      default:
        throw ArgumentError('Permissão de localização desconhecido: $value');
    }
  }

  String get label {
    switch (this) {
      case PermissaoLocalizacao.granted:
        return 'Permitido';
      case PermissaoLocalizacao.serviceDisabled:
        return 'Serviço desabilitado';
      case PermissaoLocalizacao.denied:
        return 'Negado';
      case PermissaoLocalizacao.deniedForever:
        return 'Negado para sempre';
    }
  }
}