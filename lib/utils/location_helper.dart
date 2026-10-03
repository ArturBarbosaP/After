import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

final localizacaoPadrao = LatLng(-19.9305005, -43.9379331);

String formatarDistancia(double meters) {
  if (meters < 1000) {
    return '${meters.round()} m';
  }
  final km = meters / 1000;
  return '${km.toStringAsFixed(1)} km';
}

Future<void> abrirRota(double latitude, double longitude) async {
  final uri = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude',
  );

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}