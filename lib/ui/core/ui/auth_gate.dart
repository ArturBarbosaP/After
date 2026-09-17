import 'package:after_project/config/supabase_config.dart';
import 'package:after_project/ui/core/ui/shell.dart';
import 'package:after_project/ui/login/widgets/tela_login.dart';
import 'package:flutter/material.dart';

class AppAuthGate extends StatelessWidget {
  const AppAuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final session = supabase.auth.currentSession;

    if (session != null) {
      return const AppShell();
    }

    return const TelaLogin();
  }
}