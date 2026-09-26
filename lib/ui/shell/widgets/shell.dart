import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/ui/cadastro_evento/widgets/tela_cadastro_evento.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/home/widgets/tela_home.dart';
import 'package:after_project/ui/mapa/widgets/tela_mapa.dart';
import 'package:after_project/ui/meus_eventos/widgets/tela_meus_eventos.dart';
import 'package:after_project/ui/shell/view_models/shell_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<StatefulWidget> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell>{
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ShellViewmodel(getIt<UserRepository>()),
      child: Consumer<ShellViewmodel>(
        builder: (context, shellViewmodel, _) {
          final screens = [
            const TelaHome(),
            const TelaMapa(),
            shellViewmodel.isOrganizador ? TelaMeusEventos() : TelaCadastroEvento(eventoId: 0) //TODO trocar pra TelaFavoritos
            //TelaPerfil
          ];

          return Scaffold(
            body: IndexedStack(
              index: _currentIndex,
              children: screens,
            ),
            floatingActionButton: shellViewmodel.isOrganizador
              ? FloatingActionButton(
                onPressed: _handleCriarEventoTap,
                backgroundColor: AppColors.appBarBackground,
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
            floatingActionButtonLocation: shellViewmodel.isOrganizador
              ? FloatingActionButtonLocation.miniCenterDocked
              : null,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.appBarBackground,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white54,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: 'Mapa'),
                BottomNavigationBarItem(icon: Icon(Icons.favorite_outline), label: 'Favoritos'),
                BottomNavigationBarItem(icon: Icon(Icons.menu_outlined), label: 'Perfil'),
              ],
            ),
          );
        },
      ),
    );
  }

  void _handleCriarEventoTap() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const TelaCadastroEvento(eventoId: 0),
      )
    );
  }
}