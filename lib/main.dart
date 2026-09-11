import 'package:after_project/config/get_it_config.dart';
import 'package:after_project/config/google_signin_config.dart';
import 'package:after_project/ui/core/themes/app_colors.dart';
import 'package:after_project/ui/login/widgets/tela_login.dart';
import 'package:flutter/material.dart';
import 'config/supabase_config.dart';

void main() async{
  await SupabaseConfig.initialize();
  await GoogleSignInConfig.initialize();
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
        useMaterial3: true,
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeForwardsPageTransitionsBuilder(
              backgroundColor: AppColors.bgTop,
            ),
            TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(
              backgroundColor: AppColors.bgTop,
            ),
          },
        ),
      ),
      home: const TelaLogin(),
    );
  }
}