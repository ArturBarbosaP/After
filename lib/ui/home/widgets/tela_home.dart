import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/home/view_models/home_viewmodel.dart';
import 'package:after_project/ui/home/widgets/home_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaHome extends StatelessWidget {
  const TelaHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomeViewmodel(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeTopBar(
        nomeUsuario: 'Artur', //TODO passar o nome e foto de perfil do usuario logado
        fotoPerfilUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRr5BkP6EdN5V6380bBWWKNnS9GKuO0YGochLPvleTWclg91-P3blaLD-k&s=10',
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
                  children: [

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