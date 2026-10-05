import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/core/ui/avatar.dart';
import 'package:after_project/ui/home/view_models/eventos_com_amigos.dart';
import 'package:flutter/material.dart';

class EventosAoVivo extends StatelessWidget {
  final void Function(int eventId) onTap;
  final List<EventosComAmigos> eventosAoVivo;

  const EventosAoVivo({super.key, required this.onTap, required this.eventosAoVivo});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 134,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: eventosAoVivo.length,
        separatorBuilder: (_, _) => const SizedBox(width: 18),
        itemBuilder: (context, index) {
          final data = eventosAoVivo[index];
          final evento = data.evento;

          return GestureDetector(
            onTap: () => onTap(evento.id),
            child: SizedBox(
              width: 144,
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.cardEventLiveBackground,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: evento.imagemCapa != null
                          ? Image.network(
                            evento.imagemCapa!,
                            fit: BoxFit.cover,
                          )
                          : Container(
                            color: Colors.grey.shade800,
                            child: Icon(Icons.image_not_supported, color: Colors.white54),
                          ),
                      )
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.all(6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            evento.titulo,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: Colors.white,
                              height: 1.05
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            evento.endereco,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              color: Colors.white,
                              height: 1.05
                            ),
                          ),
                          if (data.amigosPresentes.isNotEmpty)...[
                            const SizedBox(height: 10),
                            Row(
                              children: data.amigosPresentes.map((amigo) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 3),
                                  child: AppAvatar(
                                    size: 24,
                                    imageUrl: amigo.urlFotoPerfil,
                                    letter: amigo.nome[0],
                                    fontSize: 10,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}