import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:task_tracker/features/auth/data/models/request_register_data.dart';
import '../data/repositories/auth_repository.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, Session?>(AuthNotifier.new);

class AuthNotifier extends AsyncNotifier<Session?> {
  @override
  Future<Session?> build() async {
    final repo = ref.watch(authRepositoryProvider);
    return repo.currentSession;
  }

  bool get isValid {
    final session = state.value;
    if (session == null) return false;
    final expiresAt = session.expiresAt;
    if (expiresAt == null) return false;
    final expiryDate = DateTime.fromMillisecondsSinceEpoch(expiresAt * 1000);
    return expiryDate.isAfter(DateTime.now());
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).login(email, password));
  }

  Future<void> register(RequestRegisterData request) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(authRepositoryProvider).register(request));
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }
}
