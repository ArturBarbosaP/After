import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/data/repositories/mensagem_repository.dart';
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
      create: (_) => ComunidadeViewmodel(getIt<UserRepository>(), getIt<MensagemRepository>(), eventoId),
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
  final _focusNode = FocusNode();
  final _scrollController = ScrollController();
  late final ComunidadeViewmodel _viewmodel;
  int _totalAnterior = 0;
  int _novasMensagens = 0;

  bool get _estaNoFinal {
    if (!_scrollController.hasClients) return true;
    final posicao = _scrollController.position;
    return posicao.maxScrollExtent - posicao.pixels <= 80;
  }

  void _onScroll() {
    if (_novasMensagens > 0 && _estaNoFinal) {
      setState(() => _novasMensagens = 0);
    }
  }

  Future<void> _rolarParaOFinal({bool animado = true}) async {
    if (!_scrollController.hasClients) return;

    if (animado) {
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }

    for (var i = 0; i < 8; i++) {
      if (!mounted || !_scrollController.hasClients) return;

      final alvo = _scrollController.position.maxScrollExtent;
      _scrollController.jumpTo(alvo);

      await WidgetsBinding.instance.endOfFrame;

      if (!mounted || !_scrollController.hasClients) return;
      if ((_scrollController.position.maxScrollExtent - alvo).abs() < 1) break;
    }

    if (mounted && _novasMensagens > 0) {
      setState(() => _novasMensagens = 0);
    }
  }

  void _onViewmodelChanged() {
    final total = _viewmodel.mensagens.length;
    if (total <= _totalAnterior) return;

    final quantidadeNovas = total - _totalAnterior;
    final primeiraCarga = _totalAnterior == 0;
    final estavaNoFinal = _estaNoFinal;
    final foiMinha = _viewmodel.mensagens.last.autorId == _viewmodel.usuarioAtual.id;
    _totalAnterior = total;

    if (primeiraCarga || foiMinha || estavaNoFinal) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _rolarParaOFinal(animado: !primeiraCarga);
      });
    } else {
      setState(() => _novasMensagens += quantidadeNovas);
    }
  }

  Future<void> _enviar() async {
    final viewmodel = context.read<ComunidadeViewmodel>();
    final texto = _controller.text;
    if (texto.trim().isEmpty || viewmodel.isEnviando) return;

    _controller.clear();
    _focusNode.requestFocus();

    final ok = await viewmodel.enviarMensagem(texto);
    if (!mounted || ok) return;

    // Falhou: devolve o texto para a pessoa não perder o que digitou.
    if (_controller.text.isEmpty) {
      _controller.text = texto;
      _controller.selection = TextSelection.collapsed(offset: texto.length);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(viewmodel.erroEnvio ?? 'Erro ao enviar mensagem.')),
    );
  }

  @override
  void initState() {
    super.initState();
    _viewmodel = context.read<ComunidadeViewmodel>();
    _viewmodel.addListener(_onViewmodelChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _viewmodel.removeListener(_onViewmodelChanged);
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
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
        child: viewmodel.isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : SafeArea(
                child: !viewmodel.chatDisponivel
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            viewmodel.mensagemErro ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                viewmodel.mensagens.isEmpty
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
                                        controller: _scrollController,
                                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                        itemCount: viewmodel.mensagens.length,
                                        itemBuilder: (context, index) {
                                          final msg = viewmodel.mensagens[index];
                                          final minha = msg.autorId == viewmodel.usuarioAtual.id;
                                          return _BalaoMensagem(
                                            nome: msg.autorNome,
                                            urlFoto: msg.autorUrlFoto,
                                            texto: msg.texto,
                                            minha: minha,
                                          );
                                        },
                                      ),
                                if (_novasMensagens > 0)
                                  Positioned(
                                    right: 20,
                                    bottom: 10,
                                    child: Badge(
                                      label: Text('$_novasMensagens'),
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: AppColors.textboxBackground,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: AppColors.textboxBorder, width: 1),
                                        ),
                                        child: IconButton(
                                          onPressed: () => _rolarParaOFinal(),
                                          icon: const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    focusNode: _focusNode,
                                    style: const TextStyle(color: Colors.black, fontSize: 14),
                                    textInputAction: TextInputAction.send,
                                    maxLength: 500,
                                    onEditingComplete: _enviar,
                                    decoration: InputDecoration(
                                      hintText: 'Mensagem',
                                      counterText: '',
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
                                    onPressed: viewmodel.isEnviando ? null : _enviar,
                                    icon: viewmodel.isEnviando
                                        ? const SizedBox(
                                            height: 18,
                                            width: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Icon(Icons.send, color: Colors.white, size: 20),
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
            AppAvatar(
              size: 35,
              imageUrl: urlFoto,
              letter: nome.isEmpty ? '?' : nome[0],
              fontSize: 16,
            ),
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