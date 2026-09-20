import 'dart:async';
import 'package:after_project/utils/datetime_helper.dart';
import 'package:flutter/material.dart';

class BarraProgressaoEvento extends StatefulWidget {
  final DateTime dataInicio;
  final DateTime dataFim;

  const BarraProgressaoEvento({super.key, required this.dataInicio, required this.dataFim});

  @override
  State<StatefulWidget> createState() => _BarraProgressaoEventoState();
}

class _BarraProgressaoEventoState extends State<BarraProgressaoEvento> {
  Timer? _timer;

  double get _progress {
    final total = widget.dataFim.difference(widget.dataInicio).inSeconds;
    if (total <= 0) return 0;

    final decorrido = DateTime.now().difference(widget.dataInicio).inSeconds;
    return (decorrido / total).clamp(0.0, 1.0);
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final periodo = formatarProgressao(widget.dataInicio, widget.dataFim);
    final horaInicio = periodo.split('-').first;
    final horaFim = periodo.split('-').last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: 10,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation(Colors.greenAccent),
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              horaInicio,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Colors.white,
              )
            ),
            Text(
              horaFim,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Colors.white,
              )
            ),
          ],
        ),
      ],
    );
  }
}