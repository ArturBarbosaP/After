String greetingForHour(int hour) {
  if (hour >= 5 && hour < 12) return 'Bom dia!';
  if (hour >= 12 && hour < 18) return 'Boa tarde!';
  if (hour >= 18 && hour < 24) return 'Boa noite!';
  return 'Boa madrugada!'; // 0h–5h
}