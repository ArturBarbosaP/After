import 'package:after_project/domain/enums/status_enum.dart';
import 'package:after_project/domain/models/evento_mapa.dart';

class EventoMapaDto {
  final int id;
  final String titulo;
  final String status;
  final String dataInicio;
  final String dataFim;
  final double latitude;
  final double longitude;

  EventoMapaDto({
    required this.id,
    required this.titulo,
    required this.status,
    required this.dataInicio,
    required this.dataFim,
    required this.latitude,
    required this.longitude
  });

  factory EventoMapaDto.fromJson(Map<String, dynamic> json) {
    return EventoMapaDto(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      status: json['status'] as String,
      dataInicio: json['data_inicio'] as String,
      dataFim: json['data_fim'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  EventoMapa toDomain() {
    return EventoMapa(
      id: id,
      titulo: titulo,
      status: Status.fromString(status),
      dataInicio: DateTime.parse(dataInicio),
      dataFim: DateTime.parse(dataFim),
      latitude: latitude,
      longitude: longitude,
    );
  }
}