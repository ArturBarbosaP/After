import 'dart:typed_data';
import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/data/services/image_service.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/core/ui/gradient_button.dart';
import 'package:after_project/ui/core/ui/textbox.dart';
import 'package:after_project/ui/core/ui/topbar.dart';
import 'package:after_project/ui/edicao_usuario/view_models/edicao_usuario_viewmodel.dart';
import 'package:after_project/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaEdicaoUsuario extends StatelessWidget {
  const TelaEdicaoUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EdicaoUsuarioViewmodel(getIt<UserRepository>()),
      child: _TelaEdicaoUsuarioBody(),
    );
  }
}

class _TelaEdicaoUsuarioBody extends StatefulWidget {
  const _TelaEdicaoUsuarioBody();

  @override
  State<StatefulWidget> createState() => _TelaEdicaoUsuarioState();
}

class _TelaEdicaoUsuarioState extends State<_TelaEdicaoUsuarioBody> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _bioController = TextEditingController();
  final _siteController = TextEditingController();

  Uint8List? _imagemSelecionada;

  void _handleEdicaoClick() {

  }

  @override
  Widget build(BuildContext context) {
    final edicaoUsuarioViewmodel = context.watch<EdicaoUsuarioViewmodel>();
    final usuario = edicaoUsuarioViewmodel.usuario;
    final imagemUsuario = usuario?.urlFotoPerfil;

    if (edicaoUsuarioViewmodel.isLoading || usuario == null){
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(child: CircularProgressIndicator(color: Colors.white)),
              const SizedBox(height: 30),
              Text(
                edicaoUsuarioViewmodel.mensagemErro ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ),
      );
    }

    return Scaffold(
      appBar: AppTopBar(
        title: 'Edição de perfil',
        backIcon: true
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
                    mainAxisAlignment: MainAxisAlignment.center, //alinhando no centro da tela (verticalmente)
                    crossAxisAlignment: CrossAxisAlignment.stretch, //esticando os componentes (horizontalmente)
                    children: [
                      const SizedBox(height: 35),
                      Text(
                        'Edição de perfil',
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
                        'Edite os detalhes do seu perfil!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 37),
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            final imagem = await getIt<ImageService>().pickImage();
                            if (imagem != null){
                              final bytes = await imagem.readAsBytes();
                              setState(() => _imagemSelecionada = bytes);
                            }
                          },
                          child: Container(
                            height: 110,
                            width: 110,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: _imagemSelecionada != null
                                  ? MemoryImage(_imagemSelecionada!)
                                  : NetworkImage(
                                  imagemUsuario != null && imagemUsuario.isNotEmpty ? imagemUsuario : '',
                                )
                              ),
                              borderRadius: BorderRadius.circular(55),
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (imagemUsuario == null && _imagemSelecionada == null)...[
                                    Text(
                                      'Selecione uma \nfoto de perfil',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white54,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Icon(Icons.add_a_photo, color: Colors.white54)
                                  ]
                                ],
                              ),
                            )
                          ),
                        ),
                      ),
                      const SizedBox(height: 37),
                      AppTextField(
                        label: 'Nome',
                        controller: _nomeController,
                        validator: Validators.nome,
                        tipoInput: TextInputType.text,
                      ),
                      const SizedBox(height: 37),
                      AppTextField(
                        label: 'Bio',
                        controller: _bioController,
                        validator: (value) => Validators.required(value, campo: 'Bio'),
                        tipoInput: TextInputType.text,
                      ),
                      const SizedBox(height: 37),
                      if (edicaoUsuarioViewmodel.isOrganizador)...[
                        AppTextField(
                          label: 'Site',
                          controller: _siteController,
                          validator: (value) => Validators.required(value, campo: 'Site'),
                          tipoInput: TextInputType.text,
                        ),
                        const SizedBox(height: 37),
                      ],
                      GradientButton(
                        text: 'Salvar perfil',
                        height: 40,
                        onTap: edicaoUsuarioViewmodel.isLoading ? null : _handleEdicaoClick,
                        loading: edicaoUsuarioViewmodel.isLoading,
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