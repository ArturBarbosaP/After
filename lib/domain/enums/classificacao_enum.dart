enum Classificacao {
  alivre,
  a6,
  a10,
  a12,
  a14,
  a16,
  a18;

  static Classificacao fromString(String value){
    switch (value) {
      case 'Livre':
        return Classificacao.alivre;
      case '6':
        return Classificacao.a6;
      case '10':
        return Classificacao.a10;
      case '12':
        return Classificacao.a12;
      case '14':
        return Classificacao.a14;
      case '16':
        return Classificacao.a16;
      case '18':
        return Classificacao.a18;
      default:
        throw ArgumentError('Classificação de evento desconhecida: $value');
    }
  }

  String get label {
    switch (this) {
      case Classificacao.alivre:
        return 'Livre';
      case Classificacao.a6:
        return '6';
      case Classificacao.a10:
        return '10';
      case Classificacao.a12:
        return '12';
      case Classificacao.a14:
        return '14';
      case Classificacao.a16:
        return '16';
      case Classificacao.a18:
        return '18';
    }
  }
}