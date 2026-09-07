enum Categoria {
  show,
  festa,
  balada,
  teatro,
  esporte,
  palestra,
  gastronomia,
  outros;

  static Categoria fromString(String value){
    switch (value) {
      case 'Show':
        return Categoria.show;
      case 'Festa':
        return Categoria.festa;
      case 'Balada':
        return Categoria.balada;
      case 'Teatro':
        return Categoria.teatro;
      case 'Esporte':
        return Categoria.esporte;
      case 'Palestra':
        return Categoria.palestra;
      case 'Gastronomia':
        return Categoria.gastronomia;
      case 'Outros':
        return Categoria.outros;
      default:
        throw ArgumentError('Categoria de evento desconhecida: $value');
    }
  }

  String get label {
    switch (this) {
      case Categoria.show:
        return 'Show';
      case Categoria.festa:
        return 'Festa';
      case Categoria.balada:
        return 'Balada';
      case Categoria.teatro:
        return 'Teatro';
      case Categoria.esporte:
        return 'Esporte';
      case Categoria.palestra:
        return 'Palestra';
      case Categoria.gastronomia:
        return 'Gastronomia';
      case Categoria.outros:
        return 'Outros';
    }
  }
}