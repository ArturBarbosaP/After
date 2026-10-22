import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/core/ui/avatar.dart';
import 'package:after_project/ui/core/ui/gradient_button.dart';
import 'package:after_project/ui/core/ui/topbar.dart';
import 'package:after_project/ui/perfil/view_models/perfil_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});
 
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PerfilViewmodel(getIt<UserRepository>()),
      child: const _TelaPerfilBody(),
    );
  }
}
 
class _TelaPerfilBody extends StatelessWidget {
  const _TelaPerfilBody();
 
  void _handleEditarPerfil() {
    // TODO abrir tela de edição do perfil
  }
 
  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<PerfilViewmodel>();
    final usuario = viewmodel.usuario;

    if (viewmodel.isLoading || usuario == null){
      return Scaffold(
        appBar: const AppTopBar(
            title: 'Meu perfil'
        ),
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
              if (viewmodel.isLoading)...[
                Center(child: CircularProgressIndicator(color: Colors.white)),
              ],
              const SizedBox(height: 30),
              Text(
                viewmodel.mensagemErro ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
      );
    }

    return Scaffold(
      appBar: const AppTopBar(
        title: 'Meu perfil'
      ),
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
        child: SafeArea(
          child: RefreshIndicator(
            color: AppColors.textboxIcon,
            backgroundColor: AppColors.textboxBackground,
            onRefresh: () => viewmodel.refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    AppAvatar(
                      size: 110,
                      imageUrl: usuario.urlFotoPerfil,
                      letter: usuario.nome.isEmpty ? '?' : usuario.nome[0],
                      fontSize: 48,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      usuario.nome,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    if (usuario.bio != null && usuario.bio!.isNotEmpty)...[
                      const SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          usuario.bio!,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    GradientButton(
                      text: 'Editar perfil',
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      loading: false,
                      borderRadius: 10,
                      width: 185,
                      onTap: _handleEditarPerfil,
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
                        color: Colors.transparent,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          )
        ),
      ),
    );
  }
}