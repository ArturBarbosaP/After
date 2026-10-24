import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/core/ui/gradient_button.dart';
import 'package:after_project/ui/core/ui/textbox.dart';
import 'package:after_project/ui/core/ui/topbar.dart';
import 'package:after_project/ui/verificacao/view_models/verificacao_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaVerificacao extends StatelessWidget {
  const TelaVerificacao({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VerificacaoViewmodel(getIt<UserRepository>()),
      child: const _TelaVerificacaoBody(),
    );
  }
}

class _TelaVerificacaoBody extends StatefulWidget {
  const _TelaVerificacaoBody();

  @override
  State<StatefulWidget> createState() => _TelaVerificacaoState();
}

class _TelaVerificacaoState extends State<_TelaVerificacaoBody> {
  final _formKey = GlobalKey<FormState>();
  final _cnpjController = TextEditingController();
  final _cpfController = TextEditingController();

  void _handleVerificarClick() {

  }


  @override
  Widget build(BuildContext context) {
    final verificacaoViewmodel = context.watch<VerificacaoViewmodel>();


    return Scaffold(
      appBar: AppTopBar(
        title: 'Verificação',
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
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 35),
                  Text(
                    'Verificação de perfil',
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
                    'Preencha os dados para verificar seu perfil!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 37),
                  if (verificacaoViewmodel.isOrganizador)...[
                    AppTextField(
                      label: 'CNPJ',
                      controller: _cnpjController,
                      tipoInput: TextInputType.text,
                    ),
                  ]
                  else ...[
                    AppTextField(
                      label: 'CPF',
                      controller: _cpfController,
                      tipoInput: TextInputType.text,
                    ),
                  ],
                  const SizedBox(height: 37),
                  Text(
                    verificacaoViewmodel.mensagemErro != null ? verificacaoViewmodel.mensagemErro! : "",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: Colors.red
                    ),
                  ),
                  const SizedBox(height: 10),
                  GradientButton(
                    text: 'Verificar',
                    height: 40,
                    onTap: verificacaoViewmodel.isLoading ? null : _handleVerificarClick,
                    loading: verificacaoViewmodel.isLoading,
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
    );
  }
}