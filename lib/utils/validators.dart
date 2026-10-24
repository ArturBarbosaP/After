import 'package:cpf_cnpj_validator/cnpj_validator.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

class Validators {
  Validators._();

  static final RegExp emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp senhaRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+$');
  static final int senhaTamanhoMinimo = 8;
  static final int nomeTamanhoMinimo = 8;
  static final int nomeTamanhoMaximo = 80;

  static String? required(String? value, {String campo = 'Este campo'}) {
    if (value == null || value.trim().isEmpty) {
      return "$campo é obrigatório";
    }
    return null;
  }

  static String? email(String? value){
    final String? obrigatorio = required(value, campo: "Email");
    if (obrigatorio != null) {
      return obrigatorio;
    }

    if (!emailRegex.hasMatch(value!.trim())){
      return "Email inválido!";
    }
    return null;
  }

  static String? senha(String? value){
    final String? obrigatorio = required(value, campo: "Senha");
    if (obrigatorio != null) {
      return obrigatorio;
    }

    if (value!.length < senhaTamanhoMinimo){
      return "A senha deve conter no mínimo $senhaTamanhoMinimo caracteres";
    }

    if (!senhaRegex.hasMatch(value)){
      return "A senha deve conter pelo menos uma letra e um número";
    }
    return null;
  }

  static String? confirmaSenha(String? value, String senhaOriginal){
    final String? obrigatorio = required(value, campo: "Confirme a senha");
    if (obrigatorio != null){
      return obrigatorio;
    }

    if (value != senhaOriginal){
      return "As senhas devem ser iguais!";
    }
    return null;
  }

  static String? nome(String? value){
    final String? obrigatorio = required(value, campo: "Nome");
    if (obrigatorio != null){
      return obrigatorio;
    }

    if (value!.length < nomeTamanhoMinimo || value.length > nomeTamanhoMaximo){
      return "O nome deve conter no mínimo $nomeTamanhoMinimo e no máximo $nomeTamanhoMinimo";
    }
    return null;
  }

  static String? cnpj(String? value){
    final String? obrigatorio = required(value, campo: "CNPJ");
    if (obrigatorio != null){
      return obrigatorio;
    }

    if (CNPJValidator.isValid(value)){
      return "O CNPJ digitado é inválido!";
    }
    return null;
  }

  static String? cpf(String? value){
    final String? obrigatorio = required(value, campo: "CPF");
    if (obrigatorio != null){
      return obrigatorio;
    }

    if (CPFValidator.isValid(value)){
      return "O CPF digitado é inválido!";
    }
    return null;
  }
}