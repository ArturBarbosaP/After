import 'package:after_project/data/repositories/auth_repository.dart';
import 'package:after_project/data/repositories/denuncia_repository.dart';
import 'package:after_project/data/repositories/evento_repository.dart';
import 'package:after_project/data/repositories/mensagem_repository.dart';
import 'package:after_project/data/repositories/user_repository.dart';
import 'package:after_project/data/services/brasil_api_service.dart';
import 'package:after_project/data/services/image_service.dart';
import 'package:after_project/data/services/location_service.dart';
import 'package:after_project/data/services/supabase_auth_service.dart';
import 'package:after_project/data/services/supabase_denuncia_service.dart';
import 'package:after_project/data/services/supabase_evento_service.dart';
import 'package:after_project/data/services/supabase_mensagem_service.dart';
import 'package:after_project/data/services/supabase_storage_service.dart';
import 'package:after_project/data/services/supabase_user_service.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

void setUpGetIt(){
  //Supabase
  getIt.registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);

  //Services
  getIt.registerLazySingleton<LocationService>(
      () => LocationService()
  );

  getIt.registerLazySingleton<ImageService>(
      () => ImageService()
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

  getIt.registerLazySingleton<SupabaseStorageService>(
      () => SupabaseStorageService(getIt<SupabaseClient>())
  );

  getIt.registerLazySingleton<SupabaseMensagemService>(
      () => SupabaseMensagemService(getIt<SupabaseClient>())
  );

  getIt.registerLazySingleton<SupabaseDenunciaService>(
      () => SupabaseDenunciaService(getIt<SupabaseClient>())
  );
  
  getIt.registerLazySingleton<BrasilApiService>(
      () => BrasilApiService(http.Client())
  );

  //Repositories
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepository(getIt<SupabaseAuthService>())
  );
  
  getIt.registerLazySingleton<UserRepository>(
      () => UserRepository(getIt<SupabaseUserService>(), getIt<SupabaseStorageService>(), getIt<BrasilApiService>())
  );
  
  getIt.registerLazySingleton<EventoRepository>(
      () => EventoRepository(getIt<SupabaseEventoService>(), getIt<SupabaseStorageService>())
  );

  getIt.registerLazySingleton<MensagemRepository>(
      () => MensagemRepository(getIt<SupabaseMensagemService>())
  );

  getIt.registerLazySingleton<DenunciaRepository>(
      () => DenunciaRepository(getIt<SupabaseDenunciaService>())
  );
}

final getIt = GetIt.instance;