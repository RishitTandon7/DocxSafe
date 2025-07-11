import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthViewModel extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  bool _useBiometric = false;
  bool get useBiometric => _useBiometric;

  bool _usePin = false;
  bool get usePin => _usePin;

  AuthViewModel() {
    _loadSettings();
  }

  void setAuthenticated(bool value) {
    _isAuthenticated = value;
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _saveDarkMode();
    notifyListeners();
  }

  Future<void> _loadSettings() async {
    String? biometric = await _storage.read(key: 'use_biometric');
    String? pin = await _storage.read(key: 'use_pin');
    String? darkMode = await _storage.read(key: 'dark_mode');

    _useBiometric = biometric == 'true';
    _usePin = pin == 'true';
    _isDarkMode = darkMode == 'true';

    notifyListeners();
  }

  Future<void> setUseBiometric(bool value) async {
    _useBiometric = value;
    await _storage.write(key: 'use_biometric', value: value.toString());
    notifyListeners();
  }

  Future<void> setUsePin(bool value) async {
    _usePin = value;
    await _storage.write(key: 'use_pin', value: value.toString());
    notifyListeners();
  }

  Future<void> _saveDarkMode() async {
    await _storage.write(key: 'dark_mode', value: _isDarkMode.toString());
  }
}
