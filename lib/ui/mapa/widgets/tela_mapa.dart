import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/domain/models/evento_mapa.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/core/ui/searchfield.dart';
import 'package:after_project/ui/core/ui/topbar.dart';
import 'package:after_project/ui/detalhe_evento/widgets/tela_detalhe_evento.dart';
import 'package:after_project/ui/mapa/view_models/mapa_viewmodel.dart';
import 'package:after_project/utils/datetime_helper.dart';
import 'package:after_project/utils/location_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

class _TelaMapaState extends State<_TelaMapaBody> with WidgetsBindingObserver {
  final _searchController = TextEditingController();
  GoogleMapController? _mapController;

  void _abrirDetalhesEvento(int eventoId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => TelaDetalheEvento(eventoId: eventoId)
      ),
    );
  }

  Future<void> _handlePesquisarTap() async {
    final termo = _searchController.text.trim().toLowerCase();
    if (termo.isEmpty) return;

    final eventos = context.read<MapaViewmodel>().eventosAoVivo;

    EventoMapa? encontrado;
    for (final evento in eventos) {
      if (evento.titulo.toLowerCase().contains(termo)) {
        encontrado = evento;
        break;
      }
    }

    if (encontrado == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nenhum evento ao vivo encontrado com esse título')),
        );
      }
      return;
    }

    await _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(encontrado.latitude, encontrado.longitude), 16),
    );

    await _mapController?.showMarkerInfoWindow(MarkerId('evento_${encontrado.id}'));
  }

  Set<Marker> _buildMarkers(List<EventoMapa> eventos) {
    return eventos.map((evento) {
      return Marker(
        markerId: MarkerId('evento_${evento.id}'),
        position: LatLng(evento.latitude, evento.longitude),
        infoWindow: InfoWindow(
          title: evento.titulo,
          snippet: formatarPeriodo(evento.dataInicio, evento.dataFim),
          onTap: () => _abrirDetalhesEvento(evento.id),
        ),
      );
    }).toSet();
  }

  void _handleEventoProximoTap(int eventoId) => _abrirDetalhesEvento(eventoId);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<MapaViewmodel>().refresh();
    }
  }

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
          child: RefreshIndicator(
            color: AppColors.textboxIcon,
            backgroundColor: AppColors.textboxBackground,
            onRefresh: () => mapaViewmodel.refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                  if (mapaViewmodel.position != null)...[
                    SizedBox(
                      height: 432,
                      child: ClipRRect(
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              mapaViewmodel.position!.latitude,
                              mapaViewmodel.position!.longitude
                            ),
                            zoom: 14
                          ),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          markers: _buildMarkers(mapaViewmodel.eventosAoVivo),
                          onMapCreated: (controller) => _mapController = controller,
                          gestureRecognizers: {
                            Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
                          },
                        ),
                      ),
                    ),
                  ]
                  else...[
                    Container(
                      height: 432,
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          'Ative a localização para ver o mapa',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ),
                  ],
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
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
                    const SizedBox(height: 30),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}