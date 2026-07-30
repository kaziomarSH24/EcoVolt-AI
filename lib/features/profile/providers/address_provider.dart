import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/address_model.dart';
import '../repositories/address_repository.dart';

final addressesProvider = AsyncNotifierProvider<AddressesNotifier, List<AddressModel>>(() {
  return AddressesNotifier();
});

class AddressesNotifier extends AsyncNotifier<List<AddressModel>> {
  @override
  Future<List<AddressModel>> build() async {
    return ref.watch(addressRepositoryProvider).getAddresses();
  }

  Future<void> addAddress(AddressModel address) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(addressRepositoryProvider).addAddress(address);
      state = AsyncValue.data(await ref.read(addressRepositoryProvider).getAddresses());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateAddress(AddressModel address) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(addressRepositoryProvider).updateAddress(address);
      state = AsyncValue.data(await ref.read(addressRepositoryProvider).getAddresses());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteAddress(String id) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(addressRepositoryProvider).deleteAddress(id);
      state = AsyncValue.data(await ref.read(addressRepositoryProvider).getAddresses());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> setDefaultAddress(String id) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(addressRepositoryProvider).setDefaultAddress(id);
      state = AsyncValue.data(await ref.read(addressRepositoryProvider).getAddresses());
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
