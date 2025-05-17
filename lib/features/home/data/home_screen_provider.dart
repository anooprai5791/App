import 'package:flutter/material.dart';

class HomeScreenProvider extends ChangeNotifier {
  String selectedLocation = "Noida Sector 128";
  List<String> savedLocations = ["Noida Sector 128", "DLF Phase 3, Gurgaon"];
  String newAddress = '';

  void selectCurrentLocation(String currentAddress) {
    selectedLocation = currentAddress;
    notifyListeners();
  }

  void selectSavedLocation(String location) {
    selectedLocation = location;
    notifyListeners();
  }

  void updateNewAddress(String val) {
    newAddress = val;
    notifyListeners();
  }

  void saveNewLocation() {
    if (newAddress.trim().isNotEmpty) {
      selectedLocation = newAddress.trim();
      savedLocations.add(selectedLocation);
      newAddress = '';
      notifyListeners();
    }
  }
}
