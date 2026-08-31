import 'package:after_project/data/repositories/auth_repository.dart';
import 'package:after_project/data/services/supabase_auth_service.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void setUpGetIt(){
  //Supabase
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  //Services
  getIt.registerLazySingleton<SupabaseAuthService>(
      () => SupabaseAuthService(getIt<SupabaseClient>())
  );

  //Viewmodels
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepository(getIt<SupabaseAuthService>())
  );
}

final getIt = GetIt.instance;