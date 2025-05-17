import 'package:flutter/material.dart';

class CartItem {
  final String title;
  int quantity;

  CartItem({required this.title, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get cartItems => _items;

  bool isInCart(String title) {
    return _items.any((item) => item.title == title);
  }

  int getQuantity(String title) {
    final item = _items.firstWhere(
      (item) => item.title == title,
      orElse: () => CartItem(title: '', quantity: 0),
    );
    return item.quantity;
  }

  void addToCart(String title) {
    final index = _items.indexWhere((item) => item.title == title);
    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(title: title));
    }
    notifyListeners();
  }

  void removeFromCart(String title) {
    final index = _items.indexWhere((item) => item.title == title);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeCompletely(String title) {
    _items.removeWhere((item) => item.title == title);
    notifyListeners();
  }
}
