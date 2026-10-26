import 'package:after_project/domain/models/empresa.dart';

class CnpjDto {
  final String razaoSocial;
  final String situacao;
  final String? erroName;
  final String? erroMessage;
  final String? erroType;

  CnpjDto({required this.razaoSocial, required this.situacao, this.erroName, this.erroMessage, this.erroType});

  factory CnpjDto.fromJson(Map<String, dynamic> json) {
    return CnpjDto(
      razaoSocial: (json['razao_social'] as String?) ?? '',
      situacao: ((json['descricao_situacao_cadastral'] as String?) ?? '').toUpperCase(),
      erroName: json['name'] as String?,
      erroMessage: json['message'] as String?,
      erroType: json['type'] as String?
    );
  }

  Empresa toDomain() => Empresa(
      razaoSocial: razaoSocial,
      ativa: situacao == 'ATIVA',
      erro: erroMessage
  );
}