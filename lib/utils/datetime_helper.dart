String greetingForHour(int hour) {
  if (hour >= 5 && hour < 12) return 'Bom dia!';
  if (hour >= 12 && hour < 18) return 'Boa tarde!';
  if (hour >= 18 && hour < 24) return 'Boa noite!';
  return 'Boa madrugada!'; // 0h–5h
}

String relativeDayLabel(DateTime data, {DateTime? agora}) {
  final now = agora ?? DateTime.now();

  final hoje = DateTime(now.year, now.month, now.day);
  final diaDoEvento = DateTime(data.year, data.month, data.day);

  final diferenca = diaDoEvento.difference(hoje).inDays;

  switch (diferenca) {
    case 0:
      return 'Hoje';
    case 1:
      return 'Amanhã';
    default:
      final dia = data.day.toString().padLeft(2, '0');
      final mes = data.month.toString().padLeft(2, '0');
      return '$dia/$mes';
  }
}

String formatarData(DateTime data) {
  return '${data.day.toString().padLeft(2, '0')}/'
      '${data.month.toString().padLeft(2, '0')}';
}

String formatarHorario(DateTime data, bool manterMinuto) {
  final hora = data.hour.toString().padLeft(2, '0');

  if (data.minute == 0 && !manterMinuto) {
    return '${hora}h';
  }

  final minuto = data.minute.toString().padLeft(2, '0');
  return '$hora:$minuto';
}

String formatarPeriodo(DateTime dataInicio, DateTime dataFim) {
  final inicio = '${formatarData(dataInicio)} • ${formatarHorario(dataInicio, false)}';

  final mesmoDia = dataInicio.year == dataFim.year &&
      dataInicio.month == dataFim.month &&
      dataInicio.day == dataFim.day;

  if (mesmoDia) {
    return '$inicio - ${formatarHorario(dataFim, false)}';
  }

  final fim = '${formatarData(dataFim)} • ${formatarHorario(dataFim, false)}';

  return '$inicio - $fim';
}

String formatarProgressao(DateTime dataInicio, DateTime dataFim) {
  final mesmoDia = dataInicio.year == dataFim.year &&
      dataInicio.month == dataFim.month &&
      dataInicio.day == dataFim.day;

  if (mesmoDia) {
    return '${formatarHorario(dataInicio, true)} - '
        '${formatarHorario(dataFim, true)}';
  }

  return '${formatarData(dataInicio)} • ${formatarHorario(dataInicio, true)} - '
      '${formatarData(dataFim)} • ${formatarHorario(dataFim, true)}';
}