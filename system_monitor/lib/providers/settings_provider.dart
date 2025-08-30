import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  late SharedPreferences _prefs;
  bool _isDarkMode = false;
  bool _alwaysOnTop = false;
  bool _showCpuWidget = true;
  bool _showGpuWidget = true;
  bool _showRamWidget = true;
  bool _showNetworkWidget = true;
  bool _showBatteryWidget = true;
  bool _showTemperatureWidget = true;
  double _refreshRate = 1.0; // seconds
  bool _isMinimalMode = false;
  String _selectedTheme = 'system';

  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get alwaysOnTop => _alwaysOnTop;
  bool get showCpuWidget => _showCpuWidget;
  bool get showGpuWidget => _showGpuWidget;
  bool get showRamWidget => _showRamWidget;
  bool get showNetworkWidget => _showNetworkWidget;
  bool get showBatteryWidget => _showBatteryWidget;
  bool get showTemperatureWidget => _showTemperatureWidget;
  double get refreshRate => _refreshRate;
  bool get isMinimalMode => _isMinimalMode;
  String get selectedTheme => _selectedTheme;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    _alwaysOnTop = _prefs.getBool('alwaysOnTop') ?? false;
    _showCpuWidget = _prefs.getBool('showCpuWidget') ?? true;
    _showGpuWidget = _prefs.getBool('showGpuWidget') ?? true;
    _showRamWidget = _prefs.getBool('showRamWidget') ?? true;
    _showNetworkWidget = _prefs.getBool('showNetworkWidget') ?? true;
    _showBatteryWidget = _prefs.getBool('showBatteryWidget') ?? true;
    _showTemperatureWidget = _prefs.getBool('showTemperatureWidget') ?? true;
    _refreshRate = _prefs.getDouble('refreshRate') ?? 1.0;
    _isMinimalMode = _prefs.getBool('isMinimalMode') ?? false;
    _selectedTheme = _prefs.getString('selectedTheme') ?? 'system';
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _prefs.setBool('isDarkMode', value);
    notifyListeners();
  }

  Future<void> setAlwaysOnTop(bool value) async {
    _alwaysOnTop = value;
    await _prefs.setBool('alwaysOnTop', value);
    notifyListeners();
  }

  Future<void> setShowCpuWidget(bool value) async {
    _showCpuWidget = value;
    await _prefs.setBool('showCpuWidget', value);
    notifyListeners();
  }

  Future<void> setShowGpuWidget(bool value) async {
    _showGpuWidget = value;
    await _prefs.setBool('showGpuWidget', value);
    notifyListeners();
  }

  Future<void> setShowRamWidget(bool value) async {
    _showRamWidget = value;
    await _prefs.setBool('showRamWidget', value);
    notifyListeners();
  }

  Future<void> setShowNetworkWidget(bool value) async {
    _showNetworkWidget = value;
    await _prefs.setBool('showNetworkWidget', value);
    notifyListeners();
  }

  Future<void> setShowBatteryWidget(bool value) async {
    _showBatteryWidget = value;
    await _prefs.setBool('showBatteryWidget', value);
    notifyListeners();
  }

  Future<void> setShowTemperatureWidget(bool value) async {
    _showTemperatureWidget = value;
    await _prefs.setBool('showTemperatureWidget', value);
    notifyListeners();
  }

  Future<void> setRefreshRate(double value) async {
    _refreshRate = value;
    await _prefs.setDouble('refreshRate', value);
    notifyListeners();
  }

  Future<void> setMinimalMode(bool value) async {
    _isMinimalMode = value;
    await _prefs.setBool('isMinimalMode', value);
    notifyListeners();
  }

  Future<void> setSelectedTheme(String value) async {
    _selectedTheme = value;
    await _prefs.setString('selectedTheme', value);
    notifyListeners();
  }
}
