enum Status {
  cancelado,
  finalizado,
  emAndamento,
  agendado;

  static Status fromString(String value){
    switch (value) {
      case 'Agendado':
        return Status.agendado;
      case 'Em andamento':
        return Status.emAndamento;
      case 'Finalizado':
        return Status.finalizado;
      case 'Cancelado':
        return Status.cancelado;
      default:
        throw ArgumentError('Status de evento desconhecido: $value');
    }
  }

  String get label {
    switch (this) {
      case Status.agendado:
        return 'Agendado';
      case Status.emAndamento:
        return 'Em andamento';
      case Status.finalizado:
        return 'Finalizado';
      case Status.cancelado:
        return 'Cancelado';
    }
  }
}