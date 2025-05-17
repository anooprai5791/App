import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:shortly_customer/features/profile/data/edit_profile_provider.dart';

void main() {
  group('EditProfileProvider', () {
    late EditProfileProvider provider;

    setUp(() {
      provider = EditProfileProvider();
    });

    test('Initial values are correct', () {
      expect(provider.name, '');
      expect(provider.mobile, '');
      expect(provider.address, '');
      expect(provider.profileImage, isNull);
      expect(provider.nameError, isNull);
      expect(provider.phoneError, isNull);
      expect(provider.addressError, isNull);
    });

    test('Update profile fields', () {
      provider.updateName('Ashish');
      provider.updateMobile('9876543210');
      provider.updateAddress('Noida');

      expect(provider.name, 'Ashish');
      expect(provider.mobile, '9876543210');
      expect(provider.address, 'Noida');
    });

    test('Validate fields returns false if any field is invalid', () {
      final isValid = provider.validateFields();

      expect(isValid, isFalse);
      expect(provider.nameError, isNotNull);
      expect(provider.phoneError, isNotNull);
      expect(provider.addressError, isNotNull);
    });

    test('Validate fields returns true for correct input', () {
      provider.updateName('Ashish');
      provider.updateMobile('9876543210');
      provider.updateAddress('Delhi');

      final isValid = provider.validateFields();
      expect(isValid, isTrue);
      expect(provider.nameError, isNull);
      expect(provider.phoneError, isNull);
      expect(provider.addressError, isNull);
    });

    test('Reset errors clears all error messages', () {
      provider.validateFields();
      provider.resetErrors();

      expect(provider.nameError, isNull);
      expect(provider.phoneError, isNull);
      expect(provider.addressError, isNull);
    });

    test('Image is set correctly', () {
      final file = File('path/to/fake/image.png');
      provider.updateImage(file);
      expect(provider.profileImage, file);
    });
  });
}
