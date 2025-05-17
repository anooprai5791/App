import 'package:flutter/material.dart';

class SelectProviderScreenProvider extends ChangeNotifier {
  String serviceType = 'at_salon';

  void toggleServiceType(int index) {
    serviceType = index == 0 ? 'at_salon' : 'at_home';
    notifyListeners();
  }
}
