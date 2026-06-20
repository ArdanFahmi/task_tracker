import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/providers/auth_provider.dart';

final currentUserProvider = Provider<User?>((ref) {
  final session = ref.watch(authProvider).value;
  return session?.user;
});
