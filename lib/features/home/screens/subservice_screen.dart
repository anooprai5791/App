import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortly_customer/features/cart/data/cart_provider.dart';
import 'package:shortly_customer/features/cart/screen/cart_screen.dart';
import 'package:shortly_customer/features/home/data/sub_service_pprovider.dart';
import 'package:shortly_customer/features/home/screens/select_provider.dart';

class SubServiceDetailsPage extends StatelessWidget {
  final String selectedSubService;
  final List<String> allSubServices;

  const SubServiceDetailsPage({
    super.key,
    required this.selectedSubService,
    required this.allSubServices,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SubServiceDetailsProvider(selectedSubService),
      child: _SubServiceDetailsPageBody(
        allSubServices: allSubServices,
      ),
    );
  }
}

class _SubServiceDetailsPageBody extends StatelessWidget {
  final List<String> allSubServices;

  _SubServiceDetailsPageBody({required this.allSubServices});

  final Map<String, List<Map<String, String>>> dummyServices = {
    'AC': [
      {
        'title': 'AC Installation starts at ₹299',
        'image': 'https://images.unsplash.com/photo-1596995804694-4c2b6f57b6a7?fit=crop&w=400&q=80',
      },
      {
        'title': 'Book a Visit Starts at ₹149',
        'image': 'https://images.unsplash.com/photo-1581091215367-59ab6b6e064d?fit=crop&w=400&q=80',
      },
    ],
    'Washing Machine': [
      {
        'title': 'Washing Machine Repair',
        'image': 'https://images.unsplash.com/photo-1597091039515-7cc2bb1d8238?fit=crop&w=400&q=80',
      },
    ],
    'TV': [
      {
        'title': 'TV Wall Mounting Service',
        'image': 'https://images.unsplash.com/photo-1584953986815-04e9a8658c05?fit=crop&w=400&q=80',
      },
    ],
    'Haircut': [
      {
        'title': 'Haircut starts @199',
        'image': 'https://images.unsplash.com/photo-1584953986815-04e9a8658c05?fit=crop&w=400&q=80',
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SubServiceDetailsProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    final services = dummyServices[provider.currentSelectedSubService] ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Semantics(
                    label: 'Back button',
                    button: true,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.black),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()));
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Horizontal Subservice Tabs
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: allSubServices.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final subService = allSubServices[index];
                  final isSelected = provider.currentSelectedSubService == subService;
                  return GestureDetector(
                    onTap: () => provider.changeSubService(subService),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFE0F7EC) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        subService,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.black : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Services List
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.separated(
                  itemCount: services.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final service = services[index];
                    final title = service['title']!;
                    final image = service['image']!;
                    final isInCart = cartProvider.isInCart(title);
                    final quantity = cartProvider.getQuantity(title);

                    return Semantics(
                      label: 'Service: $title',
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            // Left: Text + buttons
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    !isInCart
                                        ? ElevatedButton(
                                            onPressed: () async {
                                              if (provider.needsDialog(
                                                  provider.currentSelectedSubService, title)) {
                                                final result = await showServiceTypeDialog(context);
                                                if (result != null) {
                                                  provider.saveSaloonOption(title, result);
                                                  cartProvider.addToCart(title);
                                                }
                                              } else {
                                                cartProvider.addToCart(title);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF5D3FD3),
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10)),
                                            ),
                                            child: const Text('Add', style: TextStyle(color: Colors.white)),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE0F7EC),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  onPressed: () {
                                                    cartProvider.removeFromCart(title);
                                                    if (cartProvider.getQuantity(title) == 0) {
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text('$title removed from cart')),
                                                      );
                                                    }
                                                  },
                                                  icon: const Icon(Icons.remove, color: Colors.black),
                                                ),
                                                Text('$quantity',
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.bold, fontSize: 16)),
                                                IconButton(
                                                  onPressed: () => cartProvider.addToCart(title),
                                                  icon: const Icon(Icons.add, color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),

                            // Right: Image
                            Expanded(
                              flex: 1,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  bottomRight: Radius.circular(15),
                                ),
                                child: Image.network(
                                  image,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> showServiceTypeDialog(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Choose Service Type",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _optionButton(
                context,
                label: "Appointment at salon",
                value: "at_salon",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SelectProviderScreen(serviceTitle: "at_salon")));
                },
              ),
              const SizedBox(height: 12),
              _optionButton(
                context,
                label: "Book at your place",
                value: "at_home",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SelectProviderScreen(serviceTitle: "at_home")));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _optionButton(BuildContext context,
      {required String label, required String value, required VoidCallback onTap}) {
    return Semantics(
      label: label,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFCEF2C2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(label,
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          ),
        ),
      ),
    );
  }
}
