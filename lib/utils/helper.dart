import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:intl/intl.dart';

final moedaFormat = NumberFormat.currency(locale: "pt_BR", symbol: "R\$");

String formataCNPJ(String cnpj){
  return CNPJValidator.strip(cnpj);
}

String formataCPF(String cpf){
  return CPFValidator.strip(cpf);
}