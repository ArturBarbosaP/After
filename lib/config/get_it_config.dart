import 'package:after_project/data/repositories/auth_repository.dart';
import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/data/services/location_service.dart';
import 'package:after_project/data/services/supabase_auth_service.dart';
import 'package:after_project/data/services/supabase_evento_service.dart';
import 'package:after_project/data/services/supabase_user_service.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void setUpGetIt(){
  //Supabase
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  //Services
  getIt.registerLazySingleton<LocationService>(
      () => LocationService()
  );

  getIt.registerLazySingleton<SupabaseAuthService>(
      () => SupabaseAuthService(getIt<SupabaseClient>())
  );
  
  getIt.registerLazySingleton<SupabaseUserService>(
      () => SupabaseUserService(getIt<SupabaseClient>())
  );

  getIt.registerLazySingleton<SupabaseEventoService>(
      () => SupabaseEventoService(getIt<SupabaseClient>())
  );

  //Repositories
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepository(getIt<SupabaseAuthService>())
  );
  
  getIt.registerLazySingleton<UserRepository>(
      () => UserRepository(getIt<SupabaseUserService>())
  );
  
  getIt.registerLazySingleton<EventoRepository>(
      () => EventoRepository(getIt<SupabaseEventoService>())
  );
}

final getIt = GetIt.instance;