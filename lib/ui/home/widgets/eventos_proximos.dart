import 'package:after_project/domain/models/evento_detalhado.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/utils/datetime_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventosProximos extends StatelessWidget {
  final void Function(int eventId) onTap;
  final List<EventoDetalhado> proximosEventos;

  const EventosProximos({super.key, required this.onTap, required this.proximosEventos});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: proximosEventos.length,
      separatorBuilder: (_,_) => const SizedBox(height: 15),
      itemBuilder: (context, index) {
        final data = proximosEventos[index];
        final hora = DateFormat('HH:mm').format(data.dataInicio);
        final quando = relativeDayLabel(data.dataInicio);

        return GestureDetector(
          onTap: () => onTap(data.id),
          child: Container(
            height: 50,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            decoration: BoxDecoration(
              color: AppColors.cardEventProximosBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cardEventProximosBorder, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data.endereco,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      hora,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      quando,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        color: quando == 'Hoje' ? AppColors.textEventProximoHj :
                        quando == 'Amanhã' ? AppColors.textEventProximoAmanha :
                        AppColors.textEventProximoDepoisAmanha
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}