import 'package:after_project/domain/models/evento_detalhado.dart';
import 'package:after_project/domain/models/user_profile.dart';

class EventosComAmigos {
  final EventoDetalhado evento;
  final List<UserProfile> amigosPresentes;

  EventosComAmigos({required this.evento, required this.amigosPresentes});
}