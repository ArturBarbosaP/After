import 'dart:async';
import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/data/repositories/auth_repository.dart';
import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/core/ui/searchfield.dart';
import 'package:after_project/ui/detalhe_evento/widgets/tela_detalhe_evento.dart';
import 'package:after_project/ui/home/view_models/home_viewmodel.dart';
import 'package:after_project/ui/home/widgets/categorias_filtro.dart';
import 'package:after_project/ui/home/widgets/evento_destaque.dart';
import 'package:after_project/ui/home/widgets/eventos_ao_vivo.dart';
import 'package:after_project/ui/home/widgets/eventos_proximos.dart';
import 'package:after_project/ui/home/widgets/home_top_bar.dart';
import 'package:after_project/ui/login/widgets/tela_login.dart';
import 'package:after_project/ui/perfil/widgets/tela_perfil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaHome extends StatelessWidget {
  const TelaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewmodel(getIt<UserRepository>(), getIt<EventoRepository>(), getIt<AuthRepository>()),
      child: const _TelaHomeBody(),
    );
  }
}

class _TelaHomeBody extends StatefulWidget {
  const _TelaHomeBody();

  @override
  State<StatefulWidget> createState() => _TelaHomeState();
}

class _TelaHomeState extends State<_TelaHomeBody> with WidgetsBindingObserver {
  final _searchController = TextEditingController();
  Timer? _debounce;

  void _handleSairTap() async {
    final homeViewModel = context.read<HomeViewmodel>();

    final sucesso = await homeViewModel.logout();

    if (sucesso && mounted){
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (context) => const TelaLogin()),
            (route) => false,
      );
    }
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<HomeViewmodel>().pesquisar(_searchController.text);
    });
  }

  void _abrirDetalhesEvento(int eventoId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => TelaDetalheEvento(eventoId: eventoId)
      ),
    );
  }

  void _handlePerfilTap() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => TelaPerfil()
      ),
    );
  }

  void _handlePesquisarTap(){
    context.read<HomeViewmodel>().pesquisar(_searchController.text);
  }

  void _handleEmDestaqueTap(int eventoId) => _abrirDetalhesEvento(eventoId);
  void _handleEventoAoVivoTap(int eventoId) => _abrirDetalhesEvento(eventoId);
  void _handleEventoProximoTap(int eventoId) => _abrirDetalhesEvento(eventoId);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<HomeViewmodel>().refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewmodel>();
    final usuario = homeViewModel.usuario;
    final eventoDestaque = homeViewModel.eventoDestaque;
    final eventosAoVivo = homeViewModel.eventosAoVivo;
    final proximosEventos = homeViewModel.proximosEventos;

    return Scaffold(
      appBar: HomeTopBar(
        nomeUsuario: usuario?.nome ?? '',
        fotoPerfilUrl: usuario?.urlFotoPerfil,
        onAvatarTap: _handlePerfilTap,
        onSairTap: _handleSairTap,
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
            onRefresh: () => homeViewModel.refresh(),
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
                  if (eventoDestaque != null)...[
                    const SizedBox(height: 15),
                    Text(
                      'Em destaque',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    EventoDestaque(
                      onTap: _handleEmDestaqueTap,
                      status: eventoDestaque.status.label,
                      titulo: eventoDestaque.titulo,
                      endereco: eventoDestaque.endereco,
                      id: eventoDestaque.id,
                    ),
                  ],
                  const SizedBox(height: 15),
                  Text(
                    'Categorias',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  CategoriasFiltro(
                    categoriaSelecionada: homeViewModel.categoriaSelecionadaFiltro,
                    onCategorySelected: homeViewModel.filtrarCategoria,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Eventos ao vivo',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  EventosAoVivo(
                    onTap: _handleEventoAoVivoTap,
                    eventosAoVivo: eventosAoVivo,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Próximas horas',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  EventosProximos(
                    onTap: _handleEventoProximoTap,
                    proximosEventos: proximosEventos,
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}