import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortly_customer/core/utils/screen_utils.dart';
import 'package:shortly_customer/features/cart/data/cart_provider.dart';
import 'package:shortly_customer/route/app_pages.dart';
import 'package:shortly_customer/route/custom_navigator.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Semantics(
          label: 'Back to previous screen',
          button: true,
          child: const BackButton(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: const [
            Icon(Icons.shopping_cart_outlined, color: Colors.deepPurple),
            SizedBox(width: 8),
            Text(
              'Your cart',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.cartItems.isEmpty) {
            return const Center(
              child: Text(
                'Your cart is empty',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }
          return __midBody(cartProvider);
        },
      ),
      bottomNavigationBar: __bottomNavigation(),
    );
  }

  Widget __midBody(CartProvider cartProvider) => Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: cartProvider.cartItems.length,
          itemBuilder: (context, index) {
            final item = cartProvider.cartItems[index];
            return Semantics(
              label: '${item.title}, quantity ${item.quantity}',
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: Semantics(
                    label: 'Service icon',
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.ac_unit_rounded),
                    ),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SizedBox(
                            height: 40.h,
                            width: 100.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Semantics(
                                  label: 'Decrease quantity for ${item.title}',
                                  button: true,
                                  child: GestureDetector(
                                    onTap: () =>
                                        cartProvider.removeFromCart(item.title),
                                    child: const Icon(Icons.remove, size: 20),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    item.quantity.toString(),
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                                Semantics(
                                  label: 'Increase quantity for ${item.title}',
                                  button: true,
                                  child: GestureDetector(
                                    onTap: () =>
                                        cartProvider.addToCart(item.title),
                                    child: const Icon(Icons.add, size: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Semantics(
                    label: 'Remove ${item.title} from cart',
                    button: true,
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        cartProvider.removeCompletely(item.title);
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );

  Widget __bottomNavigation() => Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          return cartProvider.cartItems.isEmpty
              ? const SizedBox()
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Semantics(
                          label: 'Add more services',
                          button: true,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.black26),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Add Services',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Semantics(
                          label: 'Proceed to checkout',
                          button: true,
                          child: ElevatedButton(
                            onPressed: () {
                              CustomNavigator.pushTo(
                                  context, AppPages.bookingpage);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5D3FD3),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Checkout',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        },
      );
}
