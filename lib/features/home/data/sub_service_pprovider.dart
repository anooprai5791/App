import 'package:flutter/material.dart';

class SubServiceDetailsProvider extends ChangeNotifier {
  late String currentSelectedSubService;

  SubServiceDetailsProvider(String initialSubService) {
    currentSelectedSubService = initialSubService;
  }

  void changeSubService(String subService) {
    currentSelectedSubService = subService;
    notifyListeners();
  }

  final Map<String, String> saloonSelection = {};

  void saveSaloonOption(String serviceTitle, String value) {
    saloonSelection[serviceTitle] = value;
    notifyListeners();
  }

  bool needsDialog(String subService, String serviceTitle) {
    return subService == 'Haircut' && !saloonSelection.containsKey(serviceTitle);
  }
}
