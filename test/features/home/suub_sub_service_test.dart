import 'package:flutter_test/flutter_test.dart';
import 'package:shortly_customer/features/home/data/sub_sub_service_provider.dart';

void main() {
  group('SubSubServiceProvider Tests', () {
    late SubSubServiceProvider provider;

    setUp(() {
      provider = SubSubServiceProvider();
    });

    test('Initial state', () {
      expect(provider.isSearching, false);
      expect(provider.searchQuery, '');
    });

    test('Toggle search on', () {
      provider.toggleSearch();
      expect(provider.isSearching, true);
    });

    test('Toggle search off and clear query', () {
      provider.toggleSearch(); // Turn on
      provider.updateSearch('AC');
      provider.toggleSearch(); // Turn off
      expect(provider.isSearching, false);
      expect(provider.searchQuery, '');
    });

    test('Update search query', () {
      provider.updateSearch('Servicing');
      expect(provider.searchQuery, 'Servicing');
    });

    test('Cancel search', () {
      provider.toggleSearch();
      provider.updateSearch('AC');
      provider.cancelSearch();
      expect(provider.isSearching, false);
      expect(provider.searchQuery, '');
    });
  });
}
