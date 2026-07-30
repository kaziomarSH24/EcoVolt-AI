import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/address_model.dart';

final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepository(Supabase.instance.client);
});

class AddressRepository {
  final SupabaseClient _client;

  AddressRepository(this._client);

  String get currentUserId {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User not logged in');
    return user.id;
  }

  Future<List<AddressModel>> getAddresses() async {
    final response = await _client
        .from('shipping_addresses')
        .select()
        .eq('user_id', currentUserId)
        .order('is_default', ascending: false)
        .order('created_at', ascending: false);
    
    return (response as List).map((json) => AddressModel.fromJson(json)).toList();
  }

  Future<AddressModel> addAddress(AddressModel address) async {
    // If it's the first address, make it default automatically
    final currentAddresses = await getAddresses();
    final isFirst = currentAddresses.isEmpty;
    final shouldBeDefault = isFirst || address.isDefault;

    // If new address is set as default, we must unset other defaults first
    if (shouldBeDefault && !isFirst) {
      await _unsetDefaults();
    }

    final data = address.toJson();
    data['is_default'] = shouldBeDefault;
    data['user_id'] = currentUserId; // Automatically assign the current user's ID
    data.remove('id'); // let db generate id

    final response = await _client.from('shipping_addresses').insert(data).select().single();
    return AddressModel.fromJson(response);
  }

  Future<AddressModel> updateAddress(AddressModel address) async {
    if (address.isDefault) {
      await _unsetDefaults();
    }
    
    final response = await _client
        .from('shipping_addresses')
        .update(address.toJson())
        .eq('id', address.id)
        .select()
        .single();
        
    return AddressModel.fromJson(response);
  }

  Future<void> deleteAddress(String addressId) async {
    await _client.from('shipping_addresses').delete().eq('id', addressId);
  }

  Future<void> setDefaultAddress(String addressId) async {
    await _unsetDefaults();
    await _client
        .from('shipping_addresses')
        .update({'is_default': true})
        .eq('id', addressId);
  }

  Future<void> _unsetDefaults() async {
    await _client
        .from('shipping_addresses')
        .update({'is_default': false})
        .eq('user_id', currentUserId);
  }
}
