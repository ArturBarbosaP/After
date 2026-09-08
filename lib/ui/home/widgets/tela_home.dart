import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/core/ui/searchfield.dart';
import 'package:after_project/ui/home/view_models/home_viewmodel.dart';
import 'package:after_project/ui/home/widgets/categorias_filtro.dart';
import 'package:after_project/ui/home/widgets/evento_destaque.dart';
import 'package:after_project/ui/home/widgets/eventos_ao_vivo.dart';
import 'package:after_project/ui/home/widgets/home_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaHome extends StatelessWidget {
  const TelaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewmodel(getIt<UserRepository>(), getIt<EventoRepository>()),
      child: const _TelaHomeBody(),
    );
  }
}

class _TelaHomeBody extends StatefulWidget {
  const _TelaHomeBody();

  @override
  State<StatefulWidget> createState() => _TelaHomeState();
}

class _TelaHomeState extends State<_TelaHomeBody> {


  void _handlePerfilTap() {
    //TODO abrir tela de edição de perfil
  }

  void _handlePesquisarTap(){
    //TODO pesquisar pelo evento digitado
  }

  void _handleEmDestaqueTap() {
    //TODO abrir o evento em destaque
  }

  void _handleEventoAoVivoTap(){
    //TODO abrir evento ao vivo
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewmodel>();
    final usuario = homeViewModel.usuario;
    final eventoDestaque = homeViewModel.eventoDestaque;
    final eventosAoVivo = homeViewModel.eventosAoVivo;

    return Scaffold(
      appBar: HomeTopBar(
        nomeUsuario: usuario?.nome ?? '',
        fotoPerfilUrl: usuario?.urlFotoPerfil,
        onAvatarTap: _handlePerfilTap,
      ),
      body: Container(
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
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start, //alinhando no centro da tela (verticalmente)
                  crossAxisAlignment: CrossAxisAlignment.stretch, //esticando os componentes (horizontalmente)
                  children: [
                    const SizedBox(height: 25), //espaçamento
                    AppSearchField(
                      onPesquisarTap: _handlePesquisarTap,
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
                        endereco: eventoDestaque.endereco
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

                    const SizedBox(height: 25)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}