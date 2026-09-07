import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/core/ui/searchfield.dart';
import 'package:after_project/ui/home/view_models/home_viewmodel.dart';
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

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewmodel>();
    final usuario = homeViewModel.usuario;
    final eventoDestaque = homeViewModel.eventoDestaque;

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
                  mainAxisAlignment: MainAxisAlignment.center, //alinhando no centro da tela (verticalmente)
                  crossAxisAlignment: CrossAxisAlignment.stretch, //esticando os componentes (horizontalmente)
                  children: [
                    const SizedBox(height: 25), //espaçamento
                    AppSearchField(
                      onPesquisarTap: _handlePesquisarTap,
                    ),
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

                    GestureDetector(
                      onTap: _handleEmDestaqueTap,
                      child: Container(
                        padding: EdgeInsets.all(17),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [AppColors.emDestaqueGradA, AppColors.emDestaqueGradB],
                          )
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.fromLTRB(25, 8, 25, 8),
                                  decoration: BoxDecoration(
                                    color: AppColors.aoVivoBackground,
                                    borderRadius: BorderRadius.circular(33),
                                    border: Border.all(color: AppColors.aoVivoBorder, width: 1)
                                  ),
                                  child: Text(
                                    eventoDestaque?.status.label ?? 'Sem eventos', //TODO mudar pro status do evento recomendado
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  eventoDestaque?.titulo ?? 'Sem eventos', //TODO mudar pros dados do evento recomendado
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  eventoDestaque?.endereco ?? 'Sem eventos', //TODO ajustar pra texto muito grande
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),

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