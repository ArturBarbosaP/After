import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/ui/comunidade/view_models/comunidade_viewmodel.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/core/ui/avatar.dart';
import 'package:after_project/ui/core/ui/topbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
class TelaComunidade extends StatelessWidget {
  const TelaComunidade({super.key, required this.eventoId, required this.tituloEvento});
 
  final int eventoId;
  final String tituloEvento;
 
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ComunidadeViewmodel(getIt<UserRepository>(), eventoId),
      child: _TelaComunidadeBody(tituloEvento: tituloEvento),
    );
  }
}
 
class _TelaComunidadeBody extends StatefulWidget {
  const _TelaComunidadeBody({required this.tituloEvento});
 
  final String tituloEvento;
 
  @override
  State<StatefulWidget> createState() => _TelaComunidadeState();
}
 
class _TelaComunidadeState extends State<_TelaComunidadeBody> {
  final _controller = TextEditingController();
 
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
 
  void _enviar() {
    context.read<ComunidadeViewmodel>().enviarMensagem(_controller.text);
    _controller.clear();
  }
 
  @override
  Widget build(BuildContext context) {
    final viewmodel = context.watch<ComunidadeViewmodel>();
 
    return Scaffold(
      appBar: AppTopBar(
        title: widget.tituloEvento,
        backIcon: true,
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
          child: viewmodel.isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : Column(
                  children: [
                    Expanded(
                      child: viewmodel.mensagens.isEmpty
                          ? const Center(
                              child: Text(
                                'Ninguém falou nada ainda. Seja o primeiro!',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              itemCount: viewmodel.mensagens.length,
                              itemBuilder: (context, index) {
                                final msg = viewmodel.mensagens[index];
                                final minha = msg.autorId == viewmodel.usuarioAtualId;
                                return _BalaoMensagem(
                                  nome: msg.autorNome,
                                  urlFoto: msg.autorUrlFoto,
                                  texto: msg.texto,
                                  minha: minha,
                                );
                              },
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              style: const TextStyle(color: Colors.black, fontSize: 14),
                              onSubmitted: (_) => _enviar(),
                              decoration: InputDecoration(
                                hintText: 'Mensagem',
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 44,
                            width: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.btnPadraoGradA,
                                  AppColors.btnPadraoGradB,
                                  AppColors.btnPadraoGradC,
                                ],
                                stops: [0.0, 0.5, 1.0],
                              ),
                            ),
                            child: IconButton(
                              onPressed: _enviar,
                              icon: const Icon(Icons.send, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
        ),
      ),
    );
  }
}
 
class _BalaoMensagem extends StatelessWidget {
  const _BalaoMensagem({
    required this.nome,
    required this.urlFoto,
    required this.texto,
    required this.minha,
  });
 
  final String nome;
  final String? urlFoto;
  final String texto;
  final bool minha;
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: minha ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!minha) ...[
            AppAvatar(size: 35, imageUrl: urlFoto, letter: nome[0], fontSize: 16),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: minha ? Colors.greenAccent : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!minha)
                    Text(
                      nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  Text(
                    texto,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}