import 'package:after_project/ui/home/widgets/tela_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/data/repositories/auth_repository.dart';
import 'package:after_project/ui/login/view_models/login_viewmodel.dart';
import 'package:after_project/ui/cadastro/widgets/tela_cadastro.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/core/ui/gradient_text.dart';
import 'package:after_project/ui/core/ui/logo.dart';
import 'package:after_project/ui/core/ui/textbox.dart';
import 'package:after_project/ui/core/ui/gradient_button.dart';
import 'package:after_project/utils/validators.dart';

class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewmodel(getIt<AuthRepository>()),
      child: const _TelaLoginBody(),
    );
  }
}

class _TelaLoginBody extends StatefulWidget {
  const _TelaLoginBody();

  @override
  State<StatefulWidget> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<_TelaLoginBody> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _mostrarSenha = false;

  void _handleLoginClick() async {
    if (!_formKey.currentState!.validate()) return;

    final loginViewModel = context.read<LoginViewmodel>();
    
    final sucesso = await loginViewModel.loginEmailSenha(
      email: _emailController.text,
      senha: _senhaController.text
    );

    if (sucesso && mounted){
      navigatorHome();
    }
  }

  void _handleLoginGoogleTap() async {
    final loginViewModel = context.read<LoginViewmodel>();

    final sucesso = await loginViewModel.loginGoogle();

    if (sucesso && mounted){
      navigatorHome();
    }
  }

  void _handleLoginFacebookTap(){
    //TODO login com o facebook
  }

  void _handleEsqueciSenhaTap(){
    /*Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => const TelaEsqueciSenha(), TODO
        )
    );*/
    limparCampos();
  }

  void _handleCadastroTap(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => const TelaCadastro(),
      )
    );
    limparCampos();
  }

  void navigatorHome(){
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(
        builder: (context) => const TelaHome(),
      ),
      (route) => false,
    );
    limparCampos();
  }

  void limparCampos(){
    context.read<LoginViewmodel>().limparErro();
    _formKey.currentState?.reset();
  }

  @override void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = context.watch<LoginViewmodel>();
    return Scaffold( //fundo
      body: Stack(
        children: [
          Positioned.fill( //imagem de fundo
            child: Image.asset('assets/images/login_bg.jpg', fit: BoxFit.cover)
          ),
          Positioned.fill( //card transparente
            child: Padding( //espaço entre as laterais da tela
              padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 85),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xFF111111).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
            ),
          ),
          SafeArea( //pra não ficar em cima dos controles do sistema
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal:  37),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Form( //formulário com os textboxs e botão
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, //alinhando no centro da tela (verticalmente)
                      crossAxisAlignment: CrossAxisAlignment.stretch, //esticando os componentes (horizontalmente)
                      children: [
                        const SizedBox(height: 45),
                        Center(
                          child: AppLogo(size: 84),
                        ),
                        const SizedBox(height: 25), //espaçamento
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
                          "Faça login para continuar!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 56),
                        AppTextField(
                          label: "Email",
                          controller: _emailController,
                          validator: Validators.email,
                          tipoInput: TextInputType.emailAddress,
                          iconeComeco: Icon(Icons.mail_outline),
                        ),
                        const SizedBox(height: 29),
                        AppTextField(
                          label: "Senha",
                          controller: _senhaController,
                          validator: (value) => Validators.required(value, campo: "Senha"),
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
                        const SizedBox(height: 3),
                        Text(
                          loginViewModel.mensagemErro != null ? loginViewModel.mensagemErro! : "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Colors.red
                          ),
                        ),
                        const SizedBox(height: 12),
                        RichText(
                          textAlign: TextAlign.end,
                          text: TextSpan(
                              text: "Esqueci minha senha",
                              recognizer: TapGestureRecognizer()..onTap = () => _handleEsqueciSenhaTap(),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: Color(0xFFBA12F3),
                              )
                          ),
                        ),
                        const SizedBox(height: 31),
                        GradientButton(
                          text: 'Entrar',
                          height: 40,
                          onTap: loginViewModel.isLoading ? null : _handleLoginClick,
                          loading: loginViewModel.isLoading,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 25),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 13,
                              color: Colors.white,
                            ),
                            children: [
                              TextSpan(
                                  text: "Entrar sem login ",
                                  recognizer: TapGestureRecognizer()..onTap = () => navigatorHome(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                    color: Color(0xFFBA12F3),
                                  )
                              ),
                              TextSpan(text: "ou Entrar com:"),
                            ],
                          ),
                        ),
                        const SizedBox(height: 9),
                        Row(
                          mainAxisSize: MainAxisSize.min,
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
                              TextSpan(text: "Não tem uma conta ainda? "),
                              TextSpan(
                                text: "Cadastre-se!",
                                recognizer: TapGestureRecognizer()..onTap = () => _handleCadastroTap(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13,
                                  color: Color(0xFFBA12F3),
                                )
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 45),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}