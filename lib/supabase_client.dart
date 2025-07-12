import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

Future<void> initializeSupabase() async {
  await Supabase.initialize(
    url: 'https://aopsicrpzqtohtgsrrmv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFvcHNpY3JwenF0b2h0Z3Nycm12Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg1ODAwMDQsImV4cCI6MjA2NDE1NjAwNH0.buMStArRs3VogRi8KkdPs-MvlkSr7ZCcWJzi9fEDzBU',
  );
}
