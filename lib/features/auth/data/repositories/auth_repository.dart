import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_tracker/features/auth/data/models/request_register_data.dart';
import '../../../../data/supabase/supabase_client_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepository(client);
});

class AuthRepository {
  final SupabaseClient _client;
  AuthRepository(this._client);

  Session? get currentSession => _client.auth.currentSession;

  Future<Session?> login(String email, String password) async {
    final res = await _client.auth.signInWithPassword(email: email, password: password);
    return res.session;
  }

  Future<Session?> register(RequestRegisterData request) async {
    final res = await _client.auth.signUp(
      email: request.email,
      password: request.password,
      data: {'name': request.name},
    );
    return res.session;
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
