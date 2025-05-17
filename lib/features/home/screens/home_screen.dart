import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:shortly_customer/core/app_imports.dart';
import 'package:shortly_customer/core/utils/screen_utils.dart';
import 'package:shortly_customer/features/cart/screen/cart_screen.dart';
import 'package:shortly_customer/features/home/screens/subservice_screen.dart';
import 'package:shortly_customer/features/home/data/home_screen_provider.dart';
import 'package:shortly_customer/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _services = [
    {'name': 'Electrician', 'icon': Icons.electrical_services},
    {'name': 'Plumber', 'icon': Icons.plumbing},
    {'name': 'Salon', 'icon': Icons.face},
    {'name': 'Carpenter', 'icon': Icons.chair},
    {'name': 'Painter', 'icon': Icons.format_paint},
  ];

  final List<String> _carouselImages = [
    'https://via.placeholder.com/400x200',
    'https://via.placeholder.com/400x200',
    'https://via.placeholder.com/400x200',
  ];

  final Map<String, List<String>> _subServices = {
    'Electrician': ['AC', 'Washing Machine', 'Refrigerator', 'Geyser', 'Wiring', 'Short Circuit'],
    'Plumber': ['Leakage Repair', 'Tap Installation', 'Bathroom Fittings'],
    'Salon': ['Haircut', 'Beard Trim', 'Facial', 'Hair Spa'],
    'Carpenter': ['Furniture Repair', 'Door Installation'],
    'Painter': ['Wall Painting', 'Texture Painting'],
  };

  late final Map<String, GlobalKey> _sectionKeys;

  @override
  void initState() {
    super.initState();
    _sectionKeys = {for (var service in _services) service['name']: GlobalKey()};
  }

  void _scrollToService(String serviceName) {
    final key = _sectionKeys[serviceName];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeScreenProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Location Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => _showLocationSelector(context),
                      child: Semantics(
                        label: 'Current location is ${provider.selectedLocation}',
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(provider.selectedLocation,
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const Text('India',
                                    style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                            const Icon(Icons.keyboard_arrow_down_rounded, size: 20),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_cart_outlined),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()));
                      },
                    ),
                  ],
                ),

                CustomSpacers.height20,

                // Search Field
                Semantics(
                  label: 'Search for services',
                  textField: true,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for services',
                        border: InputBorder.none,
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),

                CustomSpacers.height20,
                _buildCarouselSlider(),
                CustomSpacers.height20,
                _buildHorizontalServiceList(),
                CustomSpacers.height10,

                // Sections
                for (var service in _services)
                  if (_subServices[service['name']] != null)
                    _buildServiceSection(service['name']),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselSlider() {
    return Semantics(
      label: 'Promotional carousel slider',
      child: CarouselSlider(
        items: _carouselImages.map((url) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(url, fit: BoxFit.cover, width: double.infinity),
          );
        }).toList(),
        options: CarouselOptions(
          height: 190.h,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          viewportFraction: 0.9,
        ),
      ),
    );
  }

  Widget _buildHorizontalServiceList() {
    return SizedBox(
      height: 130.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _services.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final service = _services[index];
          return GestureDetector(
            onTap: () => _scrollToService(service['name']),
            child: Semantics(
              label: 'Tap to scroll to ${service['name']} section',
              button: true,
              child: Column(
                children: [
                  Container(
                    height: 90.h,
                    width: 90.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(service['icon'], size: 30),
                  ),
                  const SizedBox(height: 6),
                  Text(service['name'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServiceSection(String serviceName) {
    final subservices = _subServices[serviceName]!;
    return Container(
      key: _sectionKeys[serviceName],
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(serviceName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          CustomSpacers.height10,
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subservices.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SubServiceDetailsPage(
                        selectedSubService: subservices[index],
                        allSubServices: subservices,
                      ),
                    ),
                  );
                },
                child: Semantics(
                  label: '${subservices[index]} under $serviceName',
                  button: true,
                  child: Column(
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(child: Icon(Icons.image, size: 30)),
                      ),
                      CustomSpacers.height6,
                      Text(
                        subservices[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showLocationSelector(BuildContext context) {
    final provider = Provider.of<HomeScreenProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<HomeScreenProvider>(
            builder: (_, p, __) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Select Location", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                ListTile(
                  leading: const Icon(Icons.my_location, color: Colors.blue),
                  title: const Text("Use Current Location"),
                  onTap: () {
                    p.selectCurrentLocation(currentAddress);
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                ...p.savedLocations.map((loc) => ListTile(
                      leading: const Icon(Icons.location_pin),
                      title: Text(loc),
                      onTap: () {
                        p.selectSavedLocation(loc);
                        Navigator.pop(context);
                      },
                    )),
                const Divider(),
                const Text("Add New Location"),
                TextField(
                  onChanged: p.updateNewAddress,
                  decoration: const InputDecoration(
                    hintText: "Enter new address",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      p.saveNewLocation();
                      Navigator.pop(context);
                    },
                    child: const Text("Save"),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
