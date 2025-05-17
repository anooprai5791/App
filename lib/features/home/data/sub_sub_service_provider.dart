import 'package:flutter/material.dart';

class SubSubServiceProvider extends ChangeNotifier {
  bool isSearching = false;
  String searchQuery = '';

  void toggleSearch() {
    isSearching = !isSearching;
    if (!isSearching) searchQuery = '';
    notifyListeners();
  }

  void updateSearch(String query) {
    searchQuery = query;
    notifyListeners();
  }

  void cancelSearch() {
    isSearching = false;
    searchQuery = '';
    notifyListeners();
  }
}
