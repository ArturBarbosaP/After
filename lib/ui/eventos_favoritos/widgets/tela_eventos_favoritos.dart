import 'dart:async';
import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/core/ui/searchfield.dart';
import 'package:after_project/ui/core/ui/topbar.dart';
import 'package:after_project/ui/detalhe_evento/widgets/tela_detalhe_evento.dart';
import 'package:after_project/ui/eventos_favoritos/view_models/eventos_favoritos_viewmodel.dart';
import 'package:after_project/utils/datetime_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaEventosFavoritos extends StatelessWidget {
  const TelaEventosFavoritos({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventosFavoritosViewmodel(getIt<EventoRepository>(), getIt<UserRepository>()),
      child: const _TelaEventosFavoritosBody(),
    );
  }
}

class _TelaEventosFavoritosBody extends StatefulWidget {
  const _TelaEventosFavoritosBody();

  @override
  State<StatefulWidget> createState() => _TelaEventosFavoritosState();
}

class _TelaEventosFavoritosState extends State<_TelaEventosFavoritosBody> {
  final _searchController = TextEditingController();
  Timer? _debounce;

  void _abrirDetalhesEvento(int eventoId) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => TelaDetalheEvento(eventoId: eventoId)
      ),
    );
  }

  void _handlePesquisarTap() {
    context.read<EventosFavoritosViewmodel>().pesquisar(_searchController.text);
  }

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<EventosFavoritosViewmodel>().pesquisar(_searchController.text);
    });
  }

  void _handleEventoTap(int eventoId) => _abrirDetalhesEvento(eventoId);

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meusEventosViewmodel = context.watch<EventosFavoritosViewmodel>();
    final eventos = meusEventosViewmodel.eventos;

    return Scaffold(
      appBar: AppTopBar(
        title: 'Eventos favoritados',
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(//fundo gradiente
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
                const SizedBox(height: 25),
                AppSearchField(
                  onPesquisarTap: _handlePesquisarTap,
                  controller: _searchController,
                ),
                const SizedBox(height: 45),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: eventos.length,
                  separatorBuilder: (_,_) => const SizedBox(height: 15),
                  itemBuilder: (context, index) {
                    final data = eventos[index];
                    return GestureDetector(
                      onTap: () => _handleEventoTap(data.id),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          color: AppColors.cardEventProximosBackground,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.cardEventProximosBorder, width: 1),
                        ),
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
                            ),
                            const SizedBox(height: 2),
                            Text(
                              maxLines: 1,
                              formatarPeriodo(data.dataInicio, data.dataFim),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 35),
              ],
            ),
          ),
        ),
      ),
    );
  }
}