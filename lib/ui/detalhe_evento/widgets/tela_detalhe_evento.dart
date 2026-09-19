import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/core/ui/gradient_button.dart';
import 'package:after_project/ui/core/ui/topbar.dart';
import 'package:after_project/ui/detalhe_evento/view_models/detalhe_evento_viewmodel.dart';
import 'package:after_project/utils/datetime_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaDetalheEvento extends StatelessWidget {
  const TelaDetalheEvento({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetalheEventoViewmodel(getIt<EventoRepository>()),
      child: const _TelaDetalheEventoBody(),
    );
  }
}

class _TelaDetalheEventoBody extends StatefulWidget {
  const _TelaDetalheEventoBody();

  @override
  State<StatefulWidget> createState() => _TelaDetalheEventoState();
}

class _TelaDetalheEventoState extends State<_TelaDetalheEventoBody> {

  void _handleComunidadeTap(){
    //TODO abrir tela da comunidade do evento
  }

  void _handleConfirmarPresencaTap(){
    //TODO confirmar presença no evento
  }

  void _handleFavoritarEventoTap(){
    //TODO marcar evento como favorito
  }

  @override
  Widget build(BuildContext context) {
    final detalheEventoViewmodel = context.watch<DetalheEventoViewmodel>();
    final evento = detalheEventoViewmodel.evento;

    return Scaffold(
      appBar: AppTopBar(
        title: evento.titulo,
        backIcon: true,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            evento.titulo,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 5),
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
                        ],
                      ),
                      const SizedBox(height: 15),
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
                      Text(
                        'Progresso do evento',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      //TODO colocar barra de progressão
                      Text(
                        'O evento não ainda não começou!',
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
                      const SizedBox(height: 20),
                      Text( //TODO se nao tiver amigos sumir com esse campo
                        'Amigos confirmados',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      //TODO colocar avatar dos amigos
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton.filled(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(AppColors.favoritoBackgroundColor),
                            ),
                            onPressed: _handleFavoritarEventoTap,
                            icon: Icon(
                              Icons.favorite_outline, //TODO preencher icon quando for favorito
                              color: AppColors.favoritoIconColor,
                            ),
                          ),
                          GradientButton(
                            text: 'Confirmar presença',
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            loading: false,
                            borderRadius: 10,
                            width: 250,
                            onTap: _handleConfirmarPresencaTap,
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
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}