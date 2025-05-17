// ignore_for_file: use_build_context_synchronously, unused_import

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shortly_customer/core/app_imports.dart';
import 'package:shortly_customer/features/location.dart';
import 'shared_preference_manager.dart';

class AppManager {
  static Future<void> initialize() async {
    // Initialize Firebase and other services
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await SharedPreferencesManager.init();
  }
}
