import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/core/ui/gradient_button.dart';
import 'package:after_project/ui/core/ui/textbox.dart';
import 'package:after_project/ui/core/ui/topbar.dart';
import 'package:after_project/ui/denuncia/view_models/denuncia_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaDenuncia extends StatelessWidget {
  final int eventoId;

  const TelaDenuncia({super.key, required this.eventoId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DenunciaViewmodel(eventoId),
      child: _TelaDenunciaBody(),
    );
  }
}

class _TelaDenunciaBody extends StatefulWidget {
  const _TelaDenunciaBody();

  @override
  State<StatefulWidget> createState() => _TelaDenunciaState();
}

class _TelaDenunciaState extends State<_TelaDenunciaBody> {
  final _formKey = GlobalKey<FormState>();
  final _denunciaController = TextEditingController();

  void _handleEnviarClick(){

  }

  @override
  Widget build(BuildContext context) {
    final denunciaViewModel = context.watch<DenunciaViewmodel>();

    return Scaffold(
      appBar: AppTopBar(
        title: 'Denúncia',
        backIcon: true,
      ),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 35),
                      Text(
                        'Denúncia',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                          height: 1.0,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Preencha o campo para enviar sua denúncia sobre evento ou mensagem ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 37),
                      AppTextField(
                        label: 'Detalhes',
                        controller: _denunciaController,
                        tipoInput: TextInputType.text,
                      ),
                      const SizedBox(height: 37),
                      Text(
                        denunciaViewModel.mensagemErro != null ? denunciaViewModel.mensagemErro! : "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: Colors.red
                        ),
                      ),
                      const SizedBox(height: 10),
                      GradientButton(
                        text: 'Enviar',
                        height: 40,
                        onTap: denunciaViewModel.isLoading ? null : _handleEnviarClick,
                        loading: denunciaViewModel.isLoading,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
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