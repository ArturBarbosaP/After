import 'dart:convert';
import 'package:http/http.dart' as http;

class BrasilApiService {
  final http.Client _client;

  BrasilApiService(this._client);

  Future<Map<String, dynamic>?> fetchCnpj(String cnpj) async {
    final response = await _client
        .get(Uri.parse('https://brasilapi.com.br/api/cnpj/v1/$cnpj'))
        .timeout(const Duration(seconds: 10));

    return jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }
}