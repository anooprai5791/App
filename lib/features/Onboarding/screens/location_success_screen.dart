import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shortly_customer/nav_bar.dart';
import 'package:shortly_customer/route/app_pages.dart';
import 'package:shortly_customer/route/custom_navigator.dart'; // Import your NavBarScreen

class LocationSuccessScreen extends StatefulWidget {
  final String area;
  final String address;

  const LocationSuccessScreen(
      {super.key, required this.area, required this.address});

  @override
  State<LocationSuccessScreen> createState() => _LocationSuccessScreenState();
}

class _LocationSuccessScreenState extends State<LocationSuccessScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      CustomNavigator.pushReplace(context, AppPages.navbar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 80, color: Colors.green),
              const SizedBox(height: 20),
              const Text(
                'Delivering service at',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.area,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.address,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
