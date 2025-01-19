library projectify_animations;

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

/// A singleton class to manage animation licenses from a remote file.
class LicenseManager {
  static const String _licenseUrl =
      'https://projectify-agnex.web.app/license.json';
  static final LicenseManager _instance = LicenseManager._internal();
  final Set<String> _validLicenses = {};
  bool _isInitialized = false;
  String? _currentLicense;

  LicenseManager._internal();

  /// Factory constructor to return the singleton instance.
  factory LicenseManager() => _instance;

  /// Fetch and load valid licenses from the remote file (called only once).
  Future<void> initializeLicenses({required String license}) async {
    if (_isInitialized) return; // Prevent reinitialization

    try {
      final response = await http.get(Uri.parse(_licenseUrl));
      if (response.statusCode == 200) {
        final licenses = jsonDecode(response.body);
        if (licenses is List) {
          _validLicenses.addAll(licenses.cast<String>());
          if (_validLicenses.contains(license)) {
            _currentLicense = license; // Save the license if it's valid
            _isInitialized = true;
          } else {
            throw Exception('Provided license is invalid.');
          }
        } else {
          throw FormatException('Invalid license data format');
        }
      } else {
        throw HttpException(
            'Failed to load licenses. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error initializing licenses: $e');
      throw Exception('Failed to initialize licenses: $e');
    }
  }

  /// Ensure the license manager is initialized before use.
  bool get isInitialized => _isInitialized;

  /// Get the current license.
  String? get currentLicense => _currentLicense;
}

/// Wrapper to serve Lottie animations with license validation.
class ProjectifyAnimation {
  final LicenseManager _licenseManager = LicenseManager();

  /// Serve a Lottie animation after license validation.
  Widget serveAnimation({
    required String animationName,
    Widget? fallbackWidget,
    BoxFit? fit,
    bool repeat = true,
    bool reverse = false,
    Animation<double>? controller,
  }) {
    if (!_licenseManager.isInitialized) {
      return fallbackWidget ??
          Center(
            child: Text(
              'LicenseManager is not initialized. Unable to display animation.',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
    }

    return Lottie.asset(
      'packages/projectify_license/assets/animations/$animationName.json',
      fit: fit,
      repeat: repeat,
      reverse: reverse,
      controller: controller,
    );
  }
}

/// Example usage of LicenseManager and ProjectifyAnimation.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize the LicenseManager once at the start of the app with the license.
    await LicenseManager().initializeLicenses(
        license: 'REWR6SGIP4AYA14R'); // Replace with actual license.
    runApp(MyApp());
  } catch (e) {
    debugPrint('App failed to initialize due to license errors: $e');
  }
}

class MyApp extends StatelessWidget {
  final ProjectifyAnimation animationHandler = ProjectifyAnimation();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Projectify Animations')),
        body: Center(
          child: animationHandler.serveAnimation(
            animationName: 'example_animation',
            fallbackWidget: Icon(Icons.error, color: Colors.red, size: 48),
          ),
        ),
      ),
    );
  }
}
