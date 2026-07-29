import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ecovolt_ai/features/profile/models/profile_model.dart';

class ProfileRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<ProfileModel?> getProfile(String userId) async {
    final data = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (data != null) {
      return ProfileModel.fromJson(data);
    }
    return null;
  }

  Future<void> updateProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? address,
    File? avatarFile,
    String? currentAvatarUrl,
  }) async {
    String? avatarUrl = currentAvatarUrl;

    if (avatarFile != null) {
      final fileExt = avatarFile.path.split('.').last;
      final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExt';
      
      await _supabase.storage.from('avatars').upload(
            fileName,
            avatarFile,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      avatarUrl = _supabase.storage.from('avatars').getPublicUrl(fileName);
    }

    final updates = {
      'id': userId, // Required for upsert
      if (fullName != null) 'full_name': fullName,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (updates.length > 1) {
      await _supabase.from('profiles').upsert(updates);
    }
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository();
});
