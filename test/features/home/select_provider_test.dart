import 'package:flutter_test/flutter_test.dart';
import 'package:shortly_customer/features/home/data/select_provider_provider.dart';
void main() {
  group('SelectProviderScreenProvider Tests', () {
    late SelectProviderScreenProvider provider;

    setUp(() {
      provider = SelectProviderScreenProvider();
    });

    test('Initial serviceType is "at_salon"', () {
      expect(provider.serviceType, equals('at_salon'));
    });

    test('Toggling index 1 switches to "at_home"', () {
      provider.toggleServiceType(1);
      expect(provider.serviceType, equals('at_home'));
    });

    test('Toggling index 0 switches back to "at_salon"', () {
      provider.toggleServiceType(0);
      expect(provider.serviceType, equals('at_salon'));
    });
  });
}
