import 'package:after_project/ui/meus_eventos/view_models/meus_eventos_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TelaMeusEventos extends StatelessWidget {
  const TelaMeusEventos({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MeusEventosViewmodel(),
      child: const _TelaMeusEventosBody(),
    );
  }
}

class _TelaMeusEventosBody extends StatefulWidget {
  const _TelaMeusEventosBody();

  @override
  State<StatefulWidget> createState() => _TelaMeusEventosState();
}

class _TelaMeusEventosState extends State<_TelaMeusEventosBody> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}