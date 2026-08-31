import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/ui/login/widgets/tela_login.dart';
import 'package:flutter/material.dart';
import 'config/supabase_config.dart';

void main() async{
  await SupabaseConfig.initialize();
  setUpGetIt();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'After',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true
      ),
      home: const TelaLogin(),
    );
  }
}