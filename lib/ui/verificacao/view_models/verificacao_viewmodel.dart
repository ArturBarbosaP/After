import 'package:flutter/material.dart';

class VerificacaoViewmodel extends ChangeNotifier {


  bool _loading = false;
  bool get isLoading => _loading;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;
}