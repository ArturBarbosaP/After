import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/data/model/supabase_cadastro_model.dart';
import 'package:after_project/data/repositories/auth_repository.dart';
import 'package:after_project/ui/cadastro/view_models/cadastro_viewmodel.dart';
import 'package:after_project/ui/core/ui/checkbox.dart';
import 'package:after_project/ui/core/ui/tela_termos_uso.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/core/ui/logo.dart';
import 'package:after_project/ui/core/ui/gradient_text.dart';
import 'package:after_project/ui/core/ui/textbox.dart';
import 'package:after_project/ui/core/ui/gradient_button.dart';
import 'package:after_project/utils/validators.dart';
import 'package:provider/provider.dart';

class TelaCadastro extends StatelessWidget {
  const TelaCadastro({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CadastroViewmodel(getIt<AuthRepository>()),
      child: const _TelaCadastroBody(),
    );
  }
}

class _TelaCadastroBody extends StatefulWidget {
  const _TelaCadastroBody();

  @override
  State<StatefulWidget> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<_TelaCadastroBody> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmaSenhaController = TextEditingController();

  bool _organizador = false;
  bool _mostrarSenha = false;
  bool _mostrarConfirmaSenha = false;
  bool _confirmouTermo = false;

  Future<void> _handleCadastroClick() async {
    if (!_formKey.currentState!.validate()) return;

    final cadastroViewModel = context.read<CadastroViewmodel>();

    final sucesso = await cadastroViewModel.cadastro(
        SupabaseCadastroModel(
          nome: _nomeController.text,
          email: _emailController.text,
          senha: _senhaController.text,
          organizador: _organizador
        )
    );

    if (sucesso && mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Conta criada com sucesso!"))
      );
      Navigator.pop(context);
      limparCampos();
    } else {
      print(cadastroViewModel.mensagemErro!);
    }

  }

  void _handleLoginTap(){
    Navigator.pop(context);
    limparCampos();
  }

  void _handleMostrarTermos(){
    Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => const TelaTermosUso(),
        )
    );
  }

  void _handleLoginGoogleTap(){

  }

  void _handleLoginFacebookTap(){

  }

  void limparCampos(){
    _nomeController.clear();
    _emailController.clear();
    _senhaController.clear();
    _confirmaSenhaController.clear();
    _organizador = false;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmaSenhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cadastroViewModel = context.watch<CadastroViewmodel>();

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
            padding: const EdgeInsets.symmetric(horizontal: 37),
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
                      Align(
                        alignment: AlignmentGeometry.topStart,
                        child: AppLogo(size: 84),
                      ),
                      const SizedBox(height: 16),
                      GradientText(
                        text: "Bem-Vindo!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                          height: 1.0,
                          color: Colors.white,
                        ),
                        gradient: LinearGradient(
                          colors: [AppColors.titleGradA, AppColors.titleGradB, AppColors.titleGradC],
                          stops: [0.0, 0.423, 1.0],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Faça o cadastro para continuar!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: _RoleToggle(
                          organizador: _organizador,
                          onChanged: (v) => setState(() => _organizador = v),
                        ),
                      ),
                      const SizedBox(height: 61),
                      AppTextField(
                        label: "Nome completo",
                        controller: _nomeController,
                        validator: Validators.nome,
                        tipoInput: TextInputType.text,
                        iconeComeco: Icon(Icons.person_outline),
                      ),
                      const SizedBox(height: 37),
                      AppTextField(
                        label: "Email",
                        controller: _emailController,
                        validator: Validators.email,
                        tipoInput: TextInputType.text,
                        iconeComeco: Icon(Icons.mail_outline),
                      ),
                      const SizedBox(height: 37),
                      AppTextField(
                        label: "Senha",
                        controller: _senhaController,
                        validator: Validators.senha,
                        tipoInput: TextInputType.visiblePassword,
                        esconderTexto: !_mostrarSenha,
                        iconeFim: IconButton(
                          icon: Icon(
                            _mostrarSenha
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _mostrarSenha = !_mostrarSenha;
                            });
                          },
                        ),
                        iconeComeco: Icon(Icons.lock_outline),
                      ),
                      const SizedBox(height: 37),
                      AppTextField(
                        label: "Confirme a senha",
                        controller: _confirmaSenhaController,
                        validator: (value) => Validators.confirmaSenha(value, _confirmaSenhaController.text),
                        tipoInput: TextInputType.visiblePassword,
                        esconderTexto: !_mostrarConfirmaSenha,
                        iconeFim: IconButton(
                          icon: Icon(
                            _mostrarConfirmaSenha
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _mostrarConfirmaSenha = !_mostrarConfirmaSenha;
                            });
                          },
                        ),
                        iconeComeco: Icon(Icons.lock_outline),
                      ),
                      const SizedBox(height: 5),
                      AppCheckboxField(
                        value: _confirmouTermo,
                        activeColor: AppColors.textboxIcon,
                        onChanged: (value) => setState(() => _confirmouTermo = value),
                        label: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(text: "Li e concordo com os "),
                              TextSpan(
                                  text: "Termos de Uso",
                                  recognizer: TapGestureRecognizer()..onTap = () => _handleMostrarTermos(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: Color(0xFFBA12F3),
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        cadastroViewModel.mensagemErro != null ? cadastroViewModel.mensagemErro! : "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Colors.red
                        ),
                      ),
                      const SizedBox(height: 41),
                      GradientButton(
                        text: "Criar conta",
                        height: 40,
                        onTap: cadastroViewModel.isLoading ? null : _handleCadastroClick,
                        loading: cadastroViewModel.isLoading,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        'Entrar com',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Image.asset(
                              'assets/images/ic_google.png',
                              width: 45,
                              height: 45,
                            ),
                            onPressed: _handleLoginGoogleTap,
                          ),
                          IconButton(
                            icon: Image.asset(
                              'assets/images/ic_facebook.png',
                              width: 45,
                              height: 45,
                            ),
                            onPressed: _handleLoginFacebookTap,
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(text: "Ja tem uma conta? "),
                            TextSpan(
                                text: "Faça login aqui!",
                                recognizer: TapGestureRecognizer()..onTap = () => _handleLoginTap(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  color: Color(0xFFBA12F3),
                                )
                            ),
                          ],
                        ),
                      ),
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

class _RoleToggle extends StatelessWidget {
  const _RoleToggle({required this.organizador, required this.onChanged});

  final bool organizador;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 29,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(33),
        border: Border.all(color: const Color(0xC2610053), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _seg("Sou usuário", !organizador, () => onChanged(false), 137),
          _seg("Sou organizador(a)", organizador, () => onChanged(true), 156),
        ],
      ),
    );
  }

  Widget _seg(String label, bool active, VoidCallback onTap, double w) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: w,
        height: 29,
        alignment: Alignment.center,
        color: active ? const Color(0xFFC758AF) : Colors.transparent,
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}