class Validators {
  Validators._();

  static final RegExp emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final RegExp senhaRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+$');
  static final int senhaTamanhoMinimo = 8;

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
}