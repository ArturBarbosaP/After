String formatarDistancia(double meters) {
  if (meters < 1000) {
    return '${meters.round()} m';
  }
  final km = meters / 1000;
  return '${km.toStringAsFixed(1)} km';
}