import 'package:flutter_test/flutter_test.dart';
import 'package:shortly_customer/features/cart/data/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  group('BookingProvider', () {
    late BookingProvider provider;

    setUp(() {
      provider = BookingProvider();
    });

    test('Initial values are correct', () {
      expect(provider.name, 'Ayush Raj');
      expect(provider.mobile, '9876543210');
      expect(provider.address, '');
      expect(provider.selectedDate, isNull);
      expect(provider.selectedTime, isNull);
      expect(provider.availableDates.length, 3);
    });

    test('Update name and mobile', () {
      provider.updateName('Rahul');
      provider.updateMobile('9999999999');
      expect(provider.name, 'Rahul');
      expect(provider.mobile, '9999999999');
    });

    test('Update address', () {
      provider.updateAddress('New Delhi');
      expect(provider.address, 'New Delhi');
    });

    test('Toggle selected date', () {
      final date = provider.availableDates.first;
      provider.toggleSelectedDate(date);
      expect(provider.selectedDate, date);

      provider.toggleSelectedDate(date); // Toggle off
      expect(provider.selectedDate, isNull);
    });

    test('Toggle selected time', () {
      final time = const TimeOfDay(hour: 10, minute: 0);
      provider.toggleSelectedTime(time);
      expect(provider.selectedTime, time);

      provider.toggleSelectedTime(time); // Toggle off
      expect(provider.selectedTime, isNull);
    });

    test('Get available times on non-today dates', () {
      provider.toggleSelectedDate(DateTime.now().add(const Duration(days: 1)));
      final times = provider.getAvailableTimes();
      expect(times, isNotEmpty);
    });

    test('canBook returns true only if both date and time are selected', () {
      expect(provider.canBook(), false);
      provider.toggleSelectedDate(provider.availableDates.first);
      expect(provider.canBook(), false);
      provider.toggleSelectedTime(const TimeOfDay(hour: 12, minute: 0));
      expect(provider.canBook(), true);
    });
  });
}
