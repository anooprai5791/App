import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingProvider extends ChangeNotifier {
  String name = 'Ayush Raj';
  String mobile = '9876543210';
  String address = '';
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  List<DateTime> availableDates = [];

  BookingProvider() {
    _generateAvailableDates();
  }

  void _generateAvailableDates() {
    DateTime now = DateTime.now();
    availableDates.clear();
    if (now.hour >= 17) {
      for (int i = 1; i <= 3; i++) {
        availableDates.add(now.add(Duration(days: i)));
      }
    } else {
      for (int i = 0; i < 3; i++) {
        availableDates.add(now.add(Duration(days: i)));
      }
    }
  }

  List<TimeOfDay> getAvailableTimes() {
    final now = DateTime.now();
    final isToday = selectedDate != null &&
        DateFormat('yyyy-MM-dd').format(selectedDate!) ==
            DateFormat('yyyy-MM-dd').format(now);

    List<TimeOfDay> times = [];
    for (int hour = 8; hour <= 19; hour++) {
      for (int min in [0, 30]) {
        final time = TimeOfDay(hour: hour, minute: min);
        final dateTime = DateTime(now.year, now.month, now.day, hour, min);
        if (!isToday || dateTime.isAfter(now)) {
          times.add(time);
        }
      }
    }
    return times;
  }

  void updateName(String value) {
    name = value;
    notifyListeners();
  }

  void updateMobile(String value) {
    mobile = value;
    notifyListeners();
  }

  void updateAddress(String value) {
    address = value;
    notifyListeners();
  }

  void toggleSelectedDate(DateTime date) {
    if (selectedDate == date) {
      selectedDate = null;
      selectedTime = null;
    } else {
      selectedDate = date;
      selectedTime = null;
    }
    notifyListeners();
  }

  void toggleSelectedTime(TimeOfDay time) {
    if (selectedTime == time) {
      selectedTime = null;
    } else {
      selectedTime = time;
    }
    notifyListeners();
  }

  bool canBook() => selectedDate != null && selectedTime != null;
}
