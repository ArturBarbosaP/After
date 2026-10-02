import 'package:after_project/domain/enums/status_enum.dart';

class EventoMapa {
  final int id;
  final String titulo;
  final Status status;
  final DateTime dataInicio;
  final DateTime dataFim;
  final double latitude;
  final double longitude;

  EventoMapa({
    required this.id,
    required this.titulo,
    required this.status,
    required this.dataInicio,
    required this.dataFim,
    required this.latitude,
    required this.longitude
  });
}