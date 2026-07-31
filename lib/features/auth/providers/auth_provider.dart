import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ecovolt_ai/features/auth/repositories/auth_repository.dart';

// Provider for AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// Stream Provider for listening to Auth State changes
final authStateProvider = StreamProvider<AuthState>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.authStateChanges;
});

// Current User Provider
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider).value;
  return authState?.session?.user ?? Supabase.instance.client.auth.currentUser;
});

// Provider to track if the user is in a password recovery flow
class PasswordRecoveryNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setRecovery(bool value) {
    state = value;
  }
}

final passwordRecoveryProvider = NotifierProvider<PasswordRecoveryNotifier, bool>(() {
  return PasswordRecoveryNotifier();
});
