
import 'package:dio/dio.dart';
import 'package:pinpoint/data/datasource/address/address_service.dart';
import 'package:pinpoint/model/address/address.dart';

class AddressRepository {
  final AddressService _addressService;

  AddressRepository(this._addressService);

  /// Fetches the list of all addresses for a given institute.
   Future<Address> getAddresses(String instituteId) async {
    try {
       final response = await _addressService.getAddress(instituteId);
      return response.data  ; 
    } on DioException catch (e) {
      // Handle Dio-specific errors (e.g., network issues)
      throw Exception('Failed to fetch addresses: ${e.message}');
    } catch (e) {
      throw Exception('An unknown error occurred.');
    }
  }

  /// Creates a new address and returns the created address from the server.
  Future<Address> createAddress(String instituteId, Address newAddress) async {
    try {
      final response = await _addressService.createAddress(instituteId, newAddress);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to create address: ${e.message}');
    }
  }

  /// Deletes an address by its ID.
  Future<void> deleteAddress(String addressId) async {
    try {
      await _addressService.deleteAddress(addressId);
    } on DioException catch (e) {
      throw Exception('Failed to delete address: ${e.message}');
    }
  }

    Future<void> updateAddress(Address address) async {
    try {
      await _addressService.updateAddress(address);
    } on DioException catch (e) {
      throw Exception('Failed to update address: ${e.message}');
    }
  }
}