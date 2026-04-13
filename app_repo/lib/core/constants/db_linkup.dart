import 'package:flutter/foundation.dart';

class AppSecrets {
  // Use 10.0.2.2 for Android Emulator, localhost for iOS/Web
  static const supabaseUrl = kDebugMode 
      ? 'http://10.0.2.2:54321' 
      : 'https://ugayfwynrapzzjuhtqio.supabase.co';
      
  static const supabaseAnonKey = kDebugMode
      ? 'YOUR_LOCAL_ANON_KEY' // Get this from 'npx supabase start' output
      : 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVnYXlmd3lucmFwenpqdWh0cWlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDkxNjU3MTAsImV4cCI6MjAyNDc0MTcxMH0._c5Jwldgjn0JQ17lOxsX_dOxUFpwtsNVnVGrgP1kRsE';
      
  static const openAiApiKey = 'your-openai-api-key-here';
}
