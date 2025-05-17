import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shortly_customer/core/app_imports.dart';
import 'package:shortly_customer/core/utils/screen_utils.dart';
import 'package:shortly_customer/features/home/data/sub_sub_service_provider.dart';

class SubSubServiceScreen extends StatelessWidget {
  SubSubServiceScreen({super.key});

  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> providers = List.generate(
    10,
    (index) => {
      'name': 'Provider ${index + 1}',
      'image': 'https://i.pravatar.cc/150?img=${index + 1}',
    },
  );

  final List<Map<String, dynamic>> subSubServices = [
    {'icon': Icons.build, 'label': 'AC Installation', 'price': 1200},
    {'icon': Icons.cleaning_services, 'label': 'AC Cleaning', 'price': 800},
    {'icon': Icons.settings, 'label': 'AC Servicing', 'price': 1000},
    {'icon': Icons.ac_unit, 'label': 'Gas Refill', 'price': 1500},
    {'icon': Icons.warning, 'label': 'Troubleshooting', 'price': 700},
    {'icon': Icons.warning, 'label': 'Troubleshooting', 'price': 700},
    {'icon': Icons.warning, 'label': 'Troubleshooting', 'price': 700},
    {'icon': Icons.warning, 'label': 'Troubleshooting', 'price': 700},
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SubSubServiceProvider(),
      child: Consumer<SubSubServiceProvider>(
        builder: (context, provider, _) {
          final filteredServices = subSubServices
              .where((service) => service['label']
                  .toLowerCase()
                  .contains(provider.searchQuery.toLowerCase()))
              .toList();

          return Scaffold(
            backgroundColor: const Color(0xFF2D4654),
            floatingActionButton: Semantics(
              label: 'Book a visit',
              button: true,
              child: FloatingActionButton.extended(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Booking initiated...")),
                  );
                },
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                label: const Text("Book a visit"),
                icon: const Icon(Icons.event_available),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // App Bar Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (provider.isSearching) {
                              provider.cancelSearch();
                              _searchController.clear();
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          child: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        provider.isSearching
                            ? Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Semantics(
                                    label: 'Search services',
                                    textField: true,
                                    child: TextField(
                                      controller: _searchController,
                                      autofocus: true,
                                      style: const TextStyle(color: Colors.white),
                                      cursorColor: Colors.amber,
                                      decoration: InputDecoration(
                                        hintText: "Search service...",
                                        hintStyle: const TextStyle(color: Colors.white54),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(0.1),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                      onChanged: provider.updateSearch,
                                    ),
                                  ),
                                ),
                              )
                            : const Spacer(),
                        IconButton(
                          icon: Icon(
                            provider.isSearching ? Icons.close : Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: provider.toggleSearch,
                        )
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Providers List
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Providers",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    CustomSpacers.height10,
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: providers.length,
                        itemBuilder: (context, index) {
                          final provider = providers[index];
                          return Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(provider['image']),
                                      radius: 30,
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  provider['name'],
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Specific services header
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Go with specific services",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    CustomSpacers.height10,

                    // Services List
                    Expanded(
                      child: filteredServices.isNotEmpty
                          ? ListView.builder(
                              itemCount: filteredServices.length,
                              itemBuilder: (context, index) {
                                final item = filteredServices[index];
                                return Semantics(
                                  label: '${item['label']}, ₹${item['price']}',
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(2, 2),
                                        )
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(item['icon'], color: Colors.black),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            item['label'],
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "₹${item['price']}",
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Text(
                                "No results found",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
