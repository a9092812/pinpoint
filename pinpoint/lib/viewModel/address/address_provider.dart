
 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/data/datasource/address/address_service.dart';
import 'package:pinpoint/model/address/address.dart';
import 'package:pinpoint/repository/address/address_repository.dart';
import 'package:pinpoint/viewModel/dio/dio_provider.dart';
import 'package:pinpoint/viewModel/storage/secure_storage_provider.dart';

final addressServiceProvider = Provider<AddressService>((ref) {
   return AddressService(ref.watch(dioProvider));
});

 final addressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepository(ref.watch(addressServiceProvider));
});

 class AddressController extends AutoDisposeAsyncNotifier<Address?> {
  
    @override
  Future<Address?> build() async {
    final storage = ref.watch(secureStorageProvider);
    final instituteId = await storage.userId;  

    if (instituteId == null) {
       return null;
    }

    final repository = ref.watch(addressRepositoryProvider);
     return repository.getAddresses(instituteId);
  }

   Future<void> createAddress(Address newAddress) async {
    final storage = ref.read(secureStorageProvider);
    final instituteId = await storage.userId;
    if (instituteId == null) return;

    final repository = ref.read(addressRepositoryProvider);
    
     state = const AsyncLoading();
     state = await AsyncValue.guard(() async {
      return repository.createAddress(instituteId, newAddress);
    });
  }
  
   Future<void> updateAddress(Address updatedAddress) async {
    final repository = ref.read(addressRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.updateAddress(updatedAddress);
       return updatedAddress;
    });
  }

   Future<void> deleteAddress(String addressId) async {
    final repository = ref.read(addressRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await repository.deleteAddress(addressId);
       return null;
    });
  }
}

 final addressControllerProvider = AutoDisposeAsyncNotifierProvider<AddressController, Address?>(() {
  return AddressController();
});
