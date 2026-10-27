import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class DenunciaViewmodel extends ChangeNotifier {
  final int id;

  DenunciaViewmodel(this.id);

  bool _loading = false;
  bool get isLoading => _loading;

  String? _mensagemErro;
  String? get mensagemErro => _mensagemErro;

}