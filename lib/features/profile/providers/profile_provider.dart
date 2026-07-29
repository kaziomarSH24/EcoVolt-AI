import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ecovolt_ai/features/auth/providers/auth_provider.dart';
import 'package:ecovolt_ai/features/profile/models/profile_model.dart';
import 'package:ecovolt_ai/features/profile/repositories/profile_repository.dart';
import 'dart:io';

final profileProvider = AsyncNotifierProvider<ProfileNotifier, ProfileModel?>(() {
  return ProfileNotifier();
});

class ProfileNotifier extends AsyncNotifier<ProfileModel?> {
  @override
  Future<ProfileModel?> build() async {
    // Listen to auth changes to refetch profile
    ref.listen(authStateProvider, (previous, next) {
      if (next.value?.session?.user != null) {
        _fetchProfile();
      } else {
        state = const AsyncValue.data(null);
      }
    });
    
    return _fetchProfileData();
  }

  Future<void> _fetchProfile() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchProfileData());
  }

  Future<ProfileModel?> _fetchProfileData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return null;
    }

    final repository = ref.read(profileRepositoryProvider);
    final profile = await repository.getProfile(user.id);
    
    // Create basic profile in UI if missing from DB (should be handled by DB trigger)
    return profile ?? ProfileModel(id: user.id);
  }

  Future<void> updateProfile({
    String? fullName,
    String? phone,
    String? address,
    File? avatarFile,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      final repository = ref.read(profileRepositoryProvider);
      await repository.updateProfile(
        userId: user.id,
        fullName: fullName,
        phone: phone,
        address: address,
        avatarFile: avatarFile,
        currentAvatarUrl: state.value?.avatarUrl,
      );

      // Refresh state
      await _fetchProfile();
    } catch (e) {
      rethrow;
    }
  }
}
