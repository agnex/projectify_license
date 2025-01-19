library projectify_animations;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

/// A class to manage animation licenses from a remote file.
class LicenseManager {
  static const String _licenseUrl =
      'https://projectify-agnex.web.app/license.json';
  Set<String> _validLicenses = {};

  LicenseManager();

  /// Fetch and load valid licenses from the remote file.
  Future<void> fetchLicenses() async {
    try {
      final response = await http.get(Uri.parse(_licenseUrl));
      if (response.statusCode == 200) {
        _validLicenses = Set<String>.from(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load licenses: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching licenses: $e');
    }
  }

  bool isLicenseValid(String license) {
    return _validLicenses.contains(license);
  }
}

/// Wrapper to serve Lottie animations with license validation.
class ProjectifyAnimation {
  final LicenseManager _licenseManager;

  ProjectifyAnimation({required LicenseManager licenseManager})
      : _licenseManager = licenseManager;

  Widget serveAnimation({
    required String animationName,
    required String license,
    BoxFit? fit,
    bool repeat = true,
    bool reverse = false,
    Animation<double>? controller,
  }) {
    // if (!_licenseManager.isLicenseValid(license)) {
    //   return Center(
    //     child: Text(
    //       'Invalid license. Unable to display animation.',
    //       style: TextStyle(color: Colors.red, fontSize: 16),
    //     ),
    //   );
    // }

    return Lottie.asset(
      'assets/animations/$animationName.json',
      fit: fit,
      repeat: repeat,
      reverse: reverse,
      controller: controller,
    );
  }
}
