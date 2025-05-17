import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortly_customer/core/app_imports.dart';
import 'package:shortly_customer/features/cart/data/cart_provider.dart';
import 'package:shortly_customer/features/cart/screen/cart_screen.dart';
import 'package:shortly_customer/features/home/data/select_provider_provider.dart';
class SelectProviderScreen extends StatelessWidget {
  final String serviceTitle;

  const SelectProviderScreen({super.key, required this.serviceTitle});

  final List<Map<String, dynamic>> dummyProviders = const [
    {'name': 'Stylist A', 'rate': 199, 'rating': 4.5},
    {'name': 'Stylist B', 'rate': 249, 'rating': 4.2},
    {'name': 'Stylist C', 'rate': 299, 'rating': 4.8},
  ];

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return ChangeNotifierProvider(
      create: (_) => SelectProviderScreenProvider(),
      child: Consumer<SelectProviderScreenProvider>(
        builder: (context, provider, _) => Scaffold(
          appBar: AppBar(
            title: const Text('Providers'),
            centerTitle: false,
            backgroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  );
                },
              )
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Semantics(
                  label: 'Toggle between At Salon or At Home services',
                  toggled: true,
                  child: ToggleButtons(
                    isSelected: [
                      provider.serviceType == 'at_salon',
                      provider.serviceType == 'at_home'
                    ],
                    onPressed: provider.toggleServiceType,
                    borderRadius: BorderRadius.circular(10),
                    selectedColor: Colors.white,
                    fillColor: Colors.deepPurple,
                    color: Colors.black87,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("At Salon"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("At Home"),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: dummyProviders.length,
                  padding: const EdgeInsets.all(16),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = dummyProviders[index];
                    final key = '${serviceTitle}_${item['name']}_${provider.serviceType}';
                    final quantity = cartProvider.getQuantity(key);

                    return Semantics(
                      label:
                          '${item['name']}, ₹${item['rate']}, rated ${item['rating']} stars',
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(item['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('₹${item['rate']}'),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.orange, size: 16),
                                  Text('${item['rating']}'),
                                ],
                              )
                            ],
                          ),
                          trailing: quantity == 0
                              ? Semantics(
                                  label: 'Add ${item['name']} to cart',
                                  button: true,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      cartProvider.addToCart(key);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                    ),
                                    child: const Text(
                                      "Add",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () =>
                                          cartProvider.removeFromCart(key),
                                    ),
                                    Text('$quantity'),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () =>
                                          cartProvider.addToCart(key),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
