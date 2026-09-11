import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/home/widgets/tela_home.dart';
import 'package:flutter/material.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<StatefulWidget> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell>{
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TelaHome(),
    /*TelaMapa(),
    TelaFavoritos(),
    TelaPerfil(),*/
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
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
  }
}