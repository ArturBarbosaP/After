import 'package:after_project/domain/models/organizador.dart';

class OrganizadorDto {
  final String id;
  final String? site;

  OrganizadorDto({required this.id, this.site});

  factory OrganizadorDto.fromJson(Map<String, dynamic> json){
    return OrganizadorDto(
      id: json['id'] as String,
      site: json['site'] as String?,
    );
  }

  Organizador toDomain(){
    return Organizador(id: id, site: site);
  }
}