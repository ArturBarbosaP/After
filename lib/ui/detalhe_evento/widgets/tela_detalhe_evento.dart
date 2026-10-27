import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/domain/enums/status_enum.dart';
import 'package:after_project/domain/models/evento_detalhado.dart';
import 'package:after_project/ui/cadastro_evento/widgets/tela_cadastro_evento.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/core/ui/avatar.dart';
import 'package:after_project/ui/core/ui/classificacao.dart';
import 'package:after_project/ui/core/ui/gradient_button.dart';
import 'package:after_project/ui/core/ui/topbar.dart';
import 'package:after_project/ui/detalhe_evento/view_models/detalhe_evento_viewmodel.dart';
import 'package:after_project/ui/detalhe_evento/widgets/progressao_evento.dart';
import 'package:after_project/utils/datetime_helper.dart';
import 'package:after_project/utils/helper.dart';
import 'package:after_project/utils/location_helper.dart';
import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:after_project/ui/comunidade/widgets/tela_comunidade.dart';

class TelaDetalheEvento extends StatelessWidget {
  const TelaDetalheEvento({super.key, required this.eventoId});

  final int eventoId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetalheEventoViewmodel(getIt<EventoRepository>(), getIt<UserRepository>(), eventoId),
      child: const _TelaDetalheEventoBody(),
    );
  }
}

class _TelaDetalheEventoBody extends StatefulWidget {
  const _TelaDetalheEventoBody();

  @override
  State<StatefulWidget> createState() => _TelaDetalheEventoState();
}

class _TelaDetalheEventoState extends State<_TelaDetalheEventoBody> with WidgetsBindingObserver {

  void _handleComunidadeTap() {
    final vm = context.read<DetalheEventoViewmodel>();

    if (!vm.verificado){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Verifique sua conta para entrar na comunidade do evento!')),
      );
      return;
    }

    final evento = vm.evento;
    if (evento == null) return;

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TelaComunidade(eventoId: evento.id, tituloEvento: evento.titulo),
      ),
    );
  }

  void _handleDenunciaTap(){
    /*Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TelaDenuncia(),
      ),
    );*/
  }

  Future<void> _handleCompartilhar(EventoDetalhado evento) async {
    final texto = [
      evento.titulo,
      'Data:  ${formatarPeriodo(evento.dataInicio, evento.dataFim)}',
      'Endereço: ${evento.endereco}',
      if (evento.preco != null) 'Valor: ${moedaFormat.format(evento.preco)}',
      'Classificação: ${evento.classificacao.label}'
    ].join('\n');

    await Clipboard.setData(ClipboardData(text: texto));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dados do evento copiados!')),
    );
  }

  Set<Marker> _buildMarkers(EventoDetalhado evento) {
    return {
      Marker(
        markerId: MarkerId('evento_${evento.id}'),
        position: LatLng(evento.latitude!, evento.longitude!),
        infoWindow: InfoWindow(
          title: evento.titulo,
          snippet: formatarPeriodo(evento.dataInicio, evento.dataFim),
        ),
      )
    };
  }

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
      context.read<DetalheEventoViewmodel>().refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final detalheEventoViewmodel = context.watch<DetalheEventoViewmodel>();
    final evento = detalheEventoViewmodel.evento;
    final amigos = detalheEventoViewmodel.amigosPresentes;

    if (detalheEventoViewmodel.isLoading || evento == null) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: CircularProgressIndicator(color: Colors.white)),
              const SizedBox(height: 30),
              Text(
                detalheEventoViewmodel.mensagemErro ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ),
      );
    }

    return Scaffold(
      appBar: AppTopBar(
        title: evento.titulo,
        backIcon: true,
        actions: true,
        iconActions: detalheEventoViewmodel.podeEditar ? Icons.edit : Icons.share,
        onActionPressed: (){
          if (detalheEventoViewmodel.podeEditar){
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => TelaCadastroEvento(eventoId: evento.id),
              ),
            );
          }
          else{
            _handleCompartilhar(evento);
          }
        },
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
            onRefresh: () => detalheEventoViewmodel.refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 15),
                        AutoScrollText(
                          evento.titulo,
                          mode: AutoScrollTextMode.bouncing,
                          velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),
                          delayBefore: const Duration(milliseconds: 1500),
                          pauseBetween: const Duration(milliseconds: 1500),
                          pauseAtEnd: const Duration(milliseconds: 1500),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '•  ${evento.organizadorNome}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '•  ${formatarPeriodo(evento.dataInicio, evento.dataFim)}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    '•  ${evento.endereco}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (evento.preco != null) ...[
                                    const SizedBox(height: 5),
                                    Text(
                                      '•  Valor: ${moedaFormat.format(evento.preco)}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            AppClassificacao(classificacao: evento.classificacao, size: 50)
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.categoriaEventoBackground,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  width: 1,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  color: AppColors.categoriaEventoBorder,
                                )
                              ),
                              child: Text(
                                evento.categoria.label,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (detalheEventoViewmodel.usuarioLogado)
                              GradientButton(
                                text: 'Entrar na comunidade',
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                loading: false,
                                borderRadius: 10,
                                width: 185,
                                onTap: _handleComunidadeTap,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.btnPadraoGradA,
                                    AppColors.btnPadraoGradB,
                                    AppColors.btnPadraoGradC,
                                  ],
                                  stops: [0.0, 0.5, 1.0],
                                ),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.transparent
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 215,
                          child: ClipRRect(
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  evento.latitude!,
                                  evento.longitude!
                                ),
                                zoom: 14
                              ),
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              markers: _buildMarkers(evento),
                              gestureRecognizers: {
                                Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer())
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton.icon(
                          onPressed: () => abrirRota(evento.latitude!, evento.longitude!),
                          icon: const Icon(Icons.directions),
                          label: const Text('Traçar rota'),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Progresso do evento',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 15),
                        if (evento.statusEfetivo == Status.emAndamento)...[
                          BarraProgressaoEvento(
                            dataInicio: evento.dataInicio,
                            dataFim: evento.dataFim,
                          ),
                        ] else
                          Text(
                            detalheEventoViewmodel.mensagemProgresso,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        const SizedBox(height: 20),
                        Text(
                          'Sobre o evento',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            evento.descricao,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (amigos.isNotEmpty)...[
                          const SizedBox(height: 20),
                          Text(
                            'Amigos confirmados',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: amigos.map((amigo) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: AppAvatar(
                                  size: 35,
                                  imageUrl: amigo.urlFotoPerfil,
                                  letter: amigo.nome[0],
                                  fontSize: 16,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                        if (detalheEventoViewmodel.usuarioLogado)...[
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.favoritoBackgroundColor,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: IconButton(
                                  onPressed: detalheEventoViewmodel.toggleFavorito,
                                  icon: Icon(
                                    size: 24,
                                    detalheEventoViewmodel.favorito ? Icons.favorite : Icons.favorite_outline,
                                    color: AppColors.favoritoIconColor,
                                  ),
                                ),
                              ),
                              GradientButton(
                                text: detalheEventoViewmodel.presenca ? 'Desmarcar presença' : 'Confirmar presença',
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                                loading: false,
                                borderRadius: 10,
                                width: 250,
                                onTap: detalheEventoViewmodel.togglePresenca,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.btnPadraoGradA,
                                    AppColors.btnPadraoGradB,
                                    AppColors.btnPadraoGradC,
                                  ],
                                  stops: [0.0, 0.5, 1.0],
                                ),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.transparent
                                ),
                              ),
                              Container(
                                height: 40,
                                width: 40,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.favoritoBackgroundColor,
                                  borderRadius: BorderRadius.circular(10)
                                ),
                                child: IconButton(
                                  onPressed: _handleDenunciaTap,
                                  icon: Icon(
                                    Icons.flag_outlined,
                                    size: 24,
                                    color: AppColors.iconDenunca,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}