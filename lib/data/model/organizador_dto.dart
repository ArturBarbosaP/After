import 'package:after_project/domain/models/organizador.dart';

class OrganizadorDto {
  final String id;
  final String? site;
  final bool verificado;

  OrganizadorDto({required this.id, this.site, required this.verificado});

  factory OrganizadorDto.fromJson(Map<String, dynamic> json){
    return OrganizadorDto(
      id: json['id'] as String,
      site: json['site'] as String?,
      verificado: json['verificado'] as bool,
    );
  }

  Organizador toDomain(){
    return Organizador(id: id, site: site, verificado: verificado);
  }
}