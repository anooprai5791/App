import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:lottie/lottie.dart';
import 'package:shortly_customer/main.dart';
import 'location_success_screen.dart';

class FetchingLocationScreen extends StatefulWidget {
  const FetchingLocationScreen({super.key});

  @override
  State<FetchingLocationScreen> createState() => _FetchingLocationScreenState();
}

class _FetchingLocationScreenState extends State<FetchingLocationScreen>
    with WidgetsBindingObserver {
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fetchUserLocation();
  }

  @override 
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If user returns from settings, retry fetching location
    if (state == AppLifecycleState.resumed && !_isFetching) {
      fetchUserLocation();
    }
  }

  Future<void> fetchUserLocation() async {
    setState(() => _isFetching = true);

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      setState(() => _isFetching = false);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isFetching = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _isFetching = false);
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;

      String areaName = place.subLocality ?? '';
      String fullAddress =
          '${place.locality ?? ''}, ${place.subAdministrativeArea ?? ''}, ${place.administrativeArea ?? ''}, ${place.postalCode ?? ''}, ${place.country ?? ''}';
      currentAddress = "${place.locality}, ${place.administrativeArea}";

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LocationSuccessScreen(
            area: areaName,
            address: fullAddress,
          ),
        ),
      );
    } catch (e) {
      debugPrint('Error fetching location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to get location. Try again.")),
      );
    }

    setState(() => _isFetching = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/location.json',
                width: 160,
                height: 160,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 24),
              const Text(
                'Fetching your location...',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'We need your location to show nearby providers',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              if (_isFetching)
                const CircularProgressIndicator()
              else
                ElevatedButton.icon(
                  icon: const Icon(Icons.my_location),
                  label: const Text("Retry"),
                  onPressed: fetchUserLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
