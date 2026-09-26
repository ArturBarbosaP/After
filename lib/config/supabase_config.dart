import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
    await Supabase.initialize(
      url: dotenv.env["SUPABASE_URL"]!,
      anonKey: dotenv.env["SUPABASE_ANON_KEY"]!,
      postgrestOptions: PostgrestClientOptions(
        schema: dotenv.env["SUPABASE_DEV_SCHEMA"]!
      )
    );
  }
}

final supabase = Supabase.instance.client;