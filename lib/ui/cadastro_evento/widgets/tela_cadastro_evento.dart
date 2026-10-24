import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/data/model/supabase_cadastro_evento_model.dart';
import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/data/services/image_service.dart';
import 'package:after_project/data/services/location_service.dart';
import 'package:after_project/domain/enums/categoria_enum.dart';
import 'package:after_project/domain/enums/classificacao_enum.dart';
import 'package:after_project/domain/enums/permissao_localizacao_enum.dart';
import 'package:after_project/domain/enums/status_enum.dart';
import 'package:after_project/ui/cadastro_evento/view_models/cadastro_evento_viewmodel.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/core/ui/gradient_button.dart';
import 'package:after_project/ui/core/ui/textbox.dart';
import 'package:after_project/ui/core/ui/topbar.dart';
import 'package:after_project/utils/location_helper.dart';
import 'package:after_project/utils/validators.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TelaCadastroEvento extends StatelessWidget {
  const TelaCadastroEvento({super.key, required this.eventoId});

  final int eventoId;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CadastroEventoViewmodel(getIt<EventoRepository>(), getIt<UserRepository>(), eventoId),
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
  final _enderecoController = TextEditingController();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();
  GoogleMapController? _formMapController;

  Categoria? _categoria;
  Status? _status;
  Classificacao? _classificacao;
  DateTime? _dataInicio;
  DateTime? _dataFim;
  double? _latitude;
  double? _longitude;
  Uint8List? _imagemSelecionada;
  String? _imagemEvento;

  bool _camposPreenchidos = false;

  Future<void> _handleCadastroClick() async {
    if (!_formKey.currentState!.validate()) return;

    if (_categoria == null || _dataInicio == null || _dataFim == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha categoria, data de início e fim')),
      );
      return;
    }
    if (_dataFim!.isBefore(_dataInicio!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A data de fim deve ser depois do início')),
      );
      return;
    }

    final cadastroEventoViewmodel = context.read<CadastroEventoViewmodel>();

    final sucesso = await cadastroEventoViewmodel.cadastro(
      SupabaseCadastroEventoModel(
        id: null,
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        categoria: _categoria!.label,
        status: Status.agendado.label,
        classificacao: _classificacao!.label,
        endereco: _enderecoController.text,
        localizacao: 'POINT($_longitude $_latitude)',
        dataInicio: _dataInicio!.toIso8601String(),
        dataFim: _dataFim!.toIso8601String(),
        preco: double.tryParse(_precoController.text),
        organizadorId: ''
      ),
      _imagemSelecionada
    );

    if (sucesso && mounted){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Evento criado com sucesso!"))
      );
      Navigator.pop(context);
      limparCampos();
    }
  }

  Future<void> _handleEdicaoClick() async {
    if (!_formKey.currentState!.validate()) return;

    if (_categoria == null || _dataInicio == null || _dataFim == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha categoria, data de início e fim')),
      );
      return;
    }
    if (!_dataFim!.isAfter(_dataInicio!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A data de fim deve ser depois do início')),
      );
      return;
    }

    final cadastroEventoViewmodel = context.read<CadastroEventoViewmodel>();

    final sucesso = await cadastroEventoViewmodel.editar(
      SupabaseCadastroEventoModel(
        id: null,
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        categoria: _categoria!.label,
        status: _status!.label,
        classificacao: _classificacao!.label,
        endereco: _enderecoController.text,
        localizacao: 'POINT($_longitude $_latitude)',
        dataInicio: _dataInicio!.toIso8601String(),
        dataFim: _dataFim!.toIso8601String(),
        preco: double.tryParse(_precoController.text),
        organizadorId: '',
        imagemCapa: _imagemEvento
      ),
      _imagemSelecionada
    );

    if (sucesso && mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Evento salvo com sucesso!"))
      );
      Navigator.pop(context);
      limparCampos();
    }
  }

  Future<DateTime?> _selecionarDataHora(DateTime? valorAtual) async {
    final data = await showDatePicker(
      context: context,
      initialDate: valorAtual ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (data == null || !mounted) return null;

    final hora = await showTimePicker(
      context: context,
      initialTime: valorAtual != null
          ? TimeOfDay.fromDateTime(valorAtual)
          : TimeOfDay.now(),
    );
    if (hora == null) return null;

    return DateTime(data.year, data.month, data.day, hora.hour, hora.minute);
  }

  Future<void> _usarLocalizacaoAtual() async {
    final locationService = getIt<LocationService>();
    final permission = await locationService.requestPermission();

    if (permission != PermissaoLocalizacao.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permissão de localização necessária')),
        );
      }
      return;
    }

    final position = await locationService.getCurrentPosition();
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });

    await _formMapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(position.latitude, position.longitude), 15)
    );
  }

  void _carregarEvento() {
    if (_camposPreenchidos) return;

    final cadastroEventoViewmodel = context.read<CadastroEventoViewmodel>();
    final evento = cadastroEventoViewmodel.evento!;

    _tituloController.text = evento.titulo;
    _descricaoController.text = evento.descricao;
    _enderecoController.text = evento.endereco;

    if (evento.preco != null){
      _precoController.text = evento.preco.toString();
    }

    _categoria = evento.categoria;
    _status = evento.status;
    _classificacao = evento.classificacao;
    _dataInicio = evento.dataInicio;
    _dataFim = evento.dataFim;
    _imagemEvento = evento.imagemCapa;

    if (evento.latitude != null && evento.longitude != null) {
      _latitude = evento.latitude;
      _longitude = evento.longitude;
    }

    _camposPreenchidos = true;
  }

  Future<void> _handleAbrirCancelarDialog() async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cancelar evento?'),
        content: const Text('Deseja cancelar o evento? Ação irreversível!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sim'),
          ),
        ],
      ),
    );

    if (confirmou == true && mounted) {
      _handleCancelarClick();
    }
  }

  void _handleCancelarClick() async {
    final cadastroEventoViewmodel = context.read<CadastroEventoViewmodel>();

    final sucesso = await cadastroEventoViewmodel.cancelar();

    if (sucesso && mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Evento cancelado com sucesso!"))
      );
      Navigator.pop(context);
      limparCampos();
    }
  }

  void limparCampos(){
    _formKey.currentState?.reset();
    _categoria = null;
    _status = null;
    _classificacao = null;
    _dataInicio = null;
    _dataFim = null;
    _latitude = null;
    _longitude = null;
    _imagemSelecionada = null;
    _imagemEvento = null;
    context.read<CadastroEventoViewmodel>().limparErro();
  }

  @override
  void dispose() {
    _enderecoController.dispose();
    _tituloController.dispose();
    _descricaoController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.textboxBorder, width: 1)
    );

    final cadastroEventoViewmodel = context.watch<CadastroEventoViewmodel>();

    if (cadastroEventoViewmodel.screenLoading){
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
                cadastroEventoViewmodel.mensagemErro ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (cadastroEventoViewmodel.edicao && cadastroEventoViewmodel.evento != null){
      _carregarEvento();
    }

    return Scaffold(
      appBar: AppTopBar(
        title: cadastroEventoViewmodel.edicao ? 'Edição de evento' : 'Cadastro de evento',
        backIcon: true,
        actions: cadastroEventoViewmodel.edicao,
        iconActions: Icons.block,
        onActionPressed: _handleAbrirCancelarDialog,
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
                        cadastroEventoViewmodel.edicao ? 'Edição de evento' : 'Cadastro de evento',
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
                        cadastroEventoViewmodel.edicao
                            ? 'Edite os detalhes do seu evento!'
                            : 'Preencha os campos para cadastrar seu evento!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 37),
                      GestureDetector(
                        onTap: () async {
                          final imagem = await getIt<ImageService>().pickImage();
                          if (imagem != null){
                            final bytes = await imagem.readAsBytes();
                            setState(() => _imagemSelecionada = bytes);
                          }
                        },
                        child: Container(
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _imagemSelecionada != null || _imagemEvento != null
                            ? ClipRRect(
                              borderRadius: BorderRadiusGeometry.circular(8),
                              child: _imagemSelecionada != null
                                ? Image.memory(_imagemSelecionada!, fit: BoxFit.cover)
                                : Image.network(_imagemEvento!, fit: BoxFit.cover)
                            )
                            : const Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Selecione uma foto para a capa do evento',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white54,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Icon(Icons.add_a_photo, color: Colors.white54)
                                ],
                              ),
                          )
                        ),
                      ),
                      const SizedBox(height: 37),
                      AppTextField(
                        label: 'Título',
                        controller: _tituloController,
                        validator: (value) => Validators.required(value, campo: 'Título'),
                        tipoInput: TextInputType.text,
                      ),
                      const SizedBox(height: 37),
                      AppTextField(
                        label: 'Descrição',
                        controller: _descricaoController,
                        validator: (value) => Validators.required(value, campo: 'Descrição'),
                        tipoInput: TextInputType.multiline,
                      ),
                      const SizedBox(height: 37),
                      DropdownButtonFormField<Categoria>(
                        initialValue: _categoria,
                        dropdownColor: AppColors.textboxBackground,
                        decoration: InputDecoration(
                          labelText: 'Categoria',
                          labelStyle: TextStyle(
                            color: AppColors.textboxText
                          ),
                          filled: true,
                          fillColor: AppColors.textboxBackground,
                            border: borderStyle,
                            enabledBorder: borderStyle,
                            focusedBorder: borderStyle.copyWith(
                              borderSide: const BorderSide(color: AppColors.textboxBorder, width: 2)
                            )
                        ),
                        items: Categoria.values
                          .map((c) => DropdownMenuItem(
                            value: c, child: Text(
                              c.label,
                              style: TextStyle(
                                color: AppColors.textboxText
                              ),
                          )))
                          .toList(),
                        onChanged: (v) => setState(() => _categoria = v),
                      ),
                      const SizedBox(height: 37),
                      DropdownButtonFormField<Classificacao>(
                        initialValue: _classificacao,
                        dropdownColor: AppColors.textboxBackground,
                        decoration: InputDecoration(
                          labelText: 'Classificação indicativa',
                          labelStyle: TextStyle(
                            color: AppColors.textboxText
                          ),
                          filled: true,
                          fillColor: AppColors.textboxBackground,
                          border: borderStyle,
                          enabledBorder: borderStyle,
                          focusedBorder: borderStyle.copyWith(
                            borderSide: const BorderSide(color: AppColors.textboxBorder, width: 2)
                          )
                        ),
                        items: Classificacao.values
                          .map((c) => DropdownMenuItem(
                            value: c, child: Text(
                              c.label == Classificacao.alivre.label ? c.label : '${c.label} anos',
                              style: TextStyle(
                                color: AppColors.textboxText
                              ),
                          )))
                            .toList(),
                        onChanged: (v) => setState(() => _classificacao = v),
                      ),
                      const SizedBox(height: 37),
                      AppTextField(
                        label: 'Endereço',
                        controller: _enderecoController,
                        validator: (value) => Validators.required(value, campo: 'Endereço'),
                        tipoInput: TextInputType.text,
                      ),
                      const SizedBox(height: 37),
                      SizedBox(
                        height: 220,
                        child: ClipRRect(
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: (_latitude != null && _longitude != null)
                                  ? LatLng(_latitude!, _longitude!)
                                  : localizacaoPadrao,
                              zoom: (_latitude != null) ? 15 : 12,
                            ),
                            onMapCreated: (controller) => _formMapController = controller,
                            onTap: (LatLng posicao) {
                              setState(() {
                                _latitude = posicao.latitude;
                                _longitude = posicao.longitude;
                              });
                            },
                            markers: (_latitude != null && _longitude != null)
                                ? {
                              Marker(
                                markerId: const MarkerId('local_evento'),
                                position: LatLng(_latitude!, _longitude!),
                              ),
                            }
                                : {},
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false, // já temos nosso próprio botão de "usar localização atual"
                            gestureRecognizers: {
                              Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton.icon(
                        onPressed: _usarLocalizacaoAtual,
                        icon: Icon(Icons.location_pin, color: AppColors.textboxIcon),
                        label: Text(
                          'Usar minha localização atual',
                          style: TextStyle(
                            color: AppColors.textboxText
                          ),
                        ),
                      ),
                      const SizedBox(height: 37),
                      ElevatedButton(
                        onPressed: cadastroEventoViewmodel.podeEditarDataInicio ?
                          () async {
                            final resultado = await _selecionarDataHora(_dataInicio);
                            if (resultado != null) setState(() => _dataInicio = resultado);
                          } : null,
                        child: Text(
                          _dataInicio == null ? 'Selecione a data de início' : DateFormat('dd/MM/yyyy HH:mm').format(_dataInicio!),
                          style: TextStyle(
                            color: AppColors.textboxText
                          ),
                        ),
                      ),
                      const SizedBox(height: 37),
                      ElevatedButton(
                        onPressed: cadastroEventoViewmodel.podeEditarDataFim ?
                          () async {
                            final resultado = await _selecionarDataHora(_dataFim);
                            if (resultado != null) setState(() => _dataFim = resultado);
                          } : null,
                        child: Text(
                          _dataFim == null ? 'Selecione a data de término' : DateFormat('dd/MM/yyyy HH:mm').format(_dataFim!),
                          style: TextStyle(
                            color: AppColors.textboxText
                          ),
                        ),
                      ),
                      if (cadastroEventoViewmodel.avisoDatas != null) ...[
                        const SizedBox(height: 10),
                        Text(
                          cadastroEventoViewmodel.avisoDatas!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: Colors.white70
                        ),
                        ),
                      ],
                      const SizedBox(height: 37),
                      AppTextField(
                        label: 'Preço (opicional)',
                        controller: _precoController,
                        tipoInput: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        cadastroEventoViewmodel.mensagemErro != null ? cadastroEventoViewmodel.mensagemErro! : "",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                          color: Colors.red
                        ),
                      ),
                      const SizedBox(height: 41),
                      GradientButton(
                        text: cadastroEventoViewmodel.edicao ? 'Salvar evento' : 'Cadastrar evento',
                        height: 40,
                        onTap: cadastroEventoViewmodel.isLoading ? null :
                          cadastroEventoViewmodel.edicao ? _handleEdicaoClick : _handleCadastroClick,
                        loading: cadastroEventoViewmodel.isLoading,
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.white,
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