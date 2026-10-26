import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/core/ui/gradient_button.dart';
import 'package:after_project/ui/core/ui/textbox.dart';
import 'package:after_project/ui/core/ui/topbar.dart';
import 'package:after_project/ui/verificacao/view_models/verificacao_viewmodel.dart';
import 'package:after_project/utils/helper.dart';
import 'package:after_project/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  DateTime? _dataNascimento;

  Future<void> _handleVerificarClick() async {
    if (!_formKey.currentState!.validate()) return;

    final verificacaoViewmodel = context.read<VerificacaoViewmodel>();

    if (!verificacaoViewmodel.isOrganizador && _dataNascimento == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha a data de nascimento!')),
      );
      return;
    }

    final sucesso = await verificacaoViewmodel.verificar(
      verificacaoViewmodel.isOrganizador ? formataCNPJ(_cnpjController.text) : formataCPF(_cpfController.text),
      _dataNascimento
    );

    if (sucesso && mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Perfil verificado com sucesso!"))
      );
      Navigator.pop(context);
      limparCampos();
    }
  }

  Future<DateTime?> _selecionarDataHora(DateTime? valorAtual) async {
    final data = await showDatePicker(
      context: context,
      initialDate: valorAtual ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (data == null || !mounted) return null;

    return DateTime(data.year, data.month, data.day);
  }

  void limparCampos(){
    _formKey.currentState?.reset();
    _dataNascimento = null;
    context.read<VerificacaoViewmodel>().limparErro();
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
                      validator: (value) => Validators.cnpj(value),
                      controller: _cnpjController,
                      tipoInput: TextInputType.text,
                    ),
                  ]
                  else ...[
                    AppTextField(
                      label: 'CPF',
                      validator: (value) => Validators.cpf(value),
                      controller: _cpfController,
                      tipoInput: TextInputType.text,
                    ),
                    const SizedBox(height: 37),
                    ElevatedButton(
                      onPressed: () async {
                        final resultado = await _selecionarDataHora(_dataNascimento);
                        if (resultado != null) setState(() => _dataNascimento = resultado);
                      },
                      child: Text(
                        _dataNascimento == null ? 'Selecione a data de nascimento' : DateFormat('dd/MM/yyyy').format(_dataNascimento!),
                        style: TextStyle(
                          color: AppColors.textboxText
                        ),
                      ),
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