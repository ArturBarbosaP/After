import 'package:after_project/ui/cadastro_evento/view_models/cadastro_evento_viewmodel.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaCadastroEvento extends StatelessWidget {
  const TelaCadastroEvento({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CadastroEventoViewmodel(),
      child: const _TelaCadastroEventoBody(),
    );
  }
}

class _TelaCadastroEventoBody extends StatefulWidget {
  const _TelaCadastroEventoBody();

  @override
  State<StatefulWidget> createState() => _TelaCadastroEventoState();
}

class _TelaCadastroEventoState extends State<_TelaCadastroEventoBody> {
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient( //fundo gradiente
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.bgTop,
              AppColors.bgMid,
              AppColors.bgTop,
            ],
            stops: [0.0, 0.5, 1.0],
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, //alinhando no centro da tela (verticalmente)
                    crossAxisAlignment: CrossAxisAlignment.stretch, //esticando os componentes (horizontalmente)
                    children: [
                      const SizedBox(height: 35),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}