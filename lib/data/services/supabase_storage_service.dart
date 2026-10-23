import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  final SupabaseClient _client;
  final String _storageName = 'after_images';

  SupabaseStorageService(this._client);

  Future<String> uploadCapaEvento({required String organizadorId, required int eventoId, required Uint8List bytes}) async {
    final path = '$organizadorId/$eventoId';

    await _client.storage.from(_storageName).uploadBinary(
      path,
      bytes,
      fileOptions: const FileOptions(upsert: true)
    );

    return _client.storage.from(_storageName).getPublicUrl(path);
  }

  Future<String> uploadFotoPerfil({required String usuarioId, required Uint8List bytes}) async {
    final path = 'fotosPerfil/$usuarioId';

    await _client.storage.from(_storageName).uploadBinary(
      path,
      bytes,
      fileOptions: const FileOptions(upsert: true)
    );

    return _client.storage.from(_storageName).getPublicUrl(path);
  }
}