import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/core/ui/searchfield.dart';
import 'package:after_project/ui/core/ui/topbar.dart';
import 'package:after_project/ui/detalhe_evento/widgets/tela_detalhe_evento.dart';
import 'package:after_project/ui/mapa/view_models/mapa_viewmodel.dart';
import 'package:after_project/utils/location_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaMapa extends StatelessWidget {
  const TelaMapa({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapaViewmodel(getIt<EventoRepository>()),
      child: const _TelaMapaBody(),
    );
  }
}

class _TelaMapaBody extends StatefulWidget {
  const _TelaMapaBody();

  @override
  State<StatefulWidget> createState() => _TelaMapaState();
}

class _TelaMapaState extends State<_TelaMapaBody> {
  final _searchController = TextEditingController();

  void _abrirDetalhesEvento(int eventoId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (context) => TelaDetalheEvento(eventoId: eventoId)
      ),
    );
  }

  void _handlePesquisarTap(){
    //TODO pesquisar pelo evento digitado
  }

  void _handleEventoProximoTap(int eventoId) => _abrirDetalhesEvento(eventoId);

  @override
  Widget build(BuildContext context) {
    final mapaViewmodel = context.watch<MapaViewmodel>();
    final eventoPerto = mapaViewmodel.eventoMaisProximo;

    return Scaffold(
      appBar: AppTopBar(
        title: 'Mapa de eventos',
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient( //fundo gradiente
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.bgTop,
              AppColors.bgMid,
              AppColors.bgBottom,
            ],
            stops: [0.0, 0.519, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 25), //espaçamento
                AppSearchField(
                  onPesquisarTap: _handlePesquisarTap,
                  controller: _searchController,
                ),
                const SizedBox(height: 45),
                Container( //TODO colocar mapa do maps aqui
                  width: 331,
                  height: 432,
                  color: Colors.white,
                ),
                const SizedBox(height: 30),
                if (eventoPerto != null) ...[
                  Text(
                    'Evento mais próximo',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () => _handleEventoProximoTap(eventoPerto.id),
                    child: Container(
                      height: 64,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.eventoProximoGradA, AppColors.eventoProximoGradB],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.eventoProximoBorder, width: 1),
                      ),
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${eventoPerto.titulo} • ${formatarDistancia(eventoPerto.distancia!)}',
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
                              eventoPerto.endereco,
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
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}