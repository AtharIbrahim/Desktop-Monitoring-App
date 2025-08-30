import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SystemInfo {
  final double cpuUsage;
  final double ramUsage;
  final double ramTotal;
  final double gpuUsage;
  final double networkUpload;
  final double networkDownload;
  final int batteryLevel;
  final bool isCharging;
  final double temperature;
  final String osVersion;
  final List<String> connectedDevices;
  final DateTime timestamp;
  
  // Extended system information
  final String computerName;
  final String userName;
  final int totalProcesses;
  final double diskUsage;
  final double diskTotal;
  final String cpuModel;
  final int cpuCores;
  final String gpuModel;
  final double uptime;
  final String architecture;
  final int screenWidth;
  final int screenHeight;
  final List<String> runningProcesses;

  SystemInfo({
    required this.cpuUsage,
    required this.ramUsage,
    required this.ramTotal,
    required this.gpuUsage,
    required this.networkUpload,
    required this.networkDownload,
    required this.batteryLevel,
    required this.isCharging,
    required this.temperature,
    required this.osVersion,
    required this.connectedDevices,
    required this.timestamp,
    required this.computerName,
    required this.userName,
    required this.totalProcesses,
    required this.diskUsage,
    required this.diskTotal,
    required this.cpuModel,
    required this.cpuCores,
    required this.gpuModel,
    required this.uptime,
    required this.architecture,
    required this.screenWidth,
    required this.screenHeight,
    required this.runningProcesses,
  });
}

class SystemMonitorProvider extends ChangeNotifier {
  Timer? _timer;
  SystemInfo? _currentInfo;
  List<SystemInfo> _history = [];
  bool _isMonitoring = false;
  final Random _random = Random();
  
  // Simulated values for demonstration
  double _simulatedCpuUsage = 15.0;
  double _simulatedRamUsage = 4.5;
  final double _totalRam = 16.0; // 16GB
  double _simulatedGpuUsage = 5.0;
  double _simulatedNetworkUp = 0.0;
  double _simulatedNetworkDown = 0.0;
  double _simulatedDiskUsage = 125.0; // GB used
  final double _totalDisk = 500.0; // 500GB total
  int _simulatedProcesses = 150;
  late DateTime _startTime;
  
  // System info cache
  String? _cachedComputerName;
  String? _cachedUserName;
  String? _cachedCpuModel;
  String? _cachedGpuModel;
  
  // Getters
  SystemInfo? get currentInfo => _currentInfo;
  List<SystemInfo> get history => _history;
  bool get isMonitoring => _isMonitoring;

  SystemMonitorProvider() {
    _startTime = DateTime.now();
    _initializeSystemInfo();
    _startMonitoring();
  }

  void _initializeSystemInfo() {
    // Initialize cached system information
    _cachedComputerName = Platform.environment['COMPUTERNAME'] ?? 'Unknown';
    _cachedUserName = Platform.environment['USERNAME'] ?? 'Unknown';
    _cachedCpuModel = 'Intel Core i7-12700K'; // Simulated
    _cachedGpuModel = 'NVIDIA GeForce RTX 3070'; // Simulated
  }

  void _startMonitoring() {
    if (_isMonitoring) return;
    
    _isMonitoring = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateSystemInfo();
    });
    
    // Initial update
    _updateSystemInfo();
  }

  void startMonitoring() {
    _startMonitoring();
  }

  void stopMonitoring() {
    _isMonitoring = false;
    _timer?.cancel();
    _timer = null;
  }

  List<String> _generateRunningProcesses() {
    final processes = [
      'chrome.exe', 'explorer.exe', 'winlogon.exe', 'dwm.exe', 'svchost.exe',
      'System', 'Registry', 'audiodg.exe', 'lsass.exe', 'services.exe',
      'conhost.exe', 'SearchFilterHost.exe', 'SearchProtocolHost.exe',
      'dart.exe', 'Code.exe', 'notepad.exe', 'taskmgr.exe', 'Discord.exe',
    ];
    
    final activeProcesses = <String>[];
    final processCount = 10 + _random.nextInt(8); // 10-17 processes
    
    for (int i = 0; i < processCount; i++) {
      final process = processes[_random.nextInt(processes.length)];
      if (!activeProcesses.contains(process)) {
        activeProcesses.add(process);
      }
    }
    
    return activeProcesses;
  }

  Future<void> _updateSystemInfo() async {
    try {
      // Simulate realistic CPU usage fluctuations
      _simulatedCpuUsage += (_random.nextDouble() - 0.5) * 10;
      _simulatedCpuUsage = _simulatedCpuUsage.clamp(5.0, 95.0);
      
      // Simulate RAM usage fluctuations
      _simulatedRamUsage += (_random.nextDouble() - 0.5) * 0.5;
      _simulatedRamUsage = _simulatedRamUsage.clamp(2.0, _totalRam * 0.9);
      
      // Simulate GPU usage
      _simulatedGpuUsage += (_random.nextDouble() - 0.5) * 15;
      _simulatedGpuUsage = _simulatedGpuUsage.clamp(0.0, 85.0);
      
      // Simulate network activity
      _simulatedNetworkUp = _random.nextDouble() * 1024 * 1024; // Up to 1MB/s
      _simulatedNetworkDown = _random.nextDouble() * 5 * 1024 * 1024; // Up to 5MB/s

      // Simulate process count changes
      _simulatedProcesses += _random.nextInt(5) - 2; // +/- 2 processes
      _simulatedProcesses = _simulatedProcesses.clamp(100, 300);

      // Simulate disk usage changes (very slow)
      if (_random.nextDouble() < 0.1) { // 10% chance
        _simulatedDiskUsage += (_random.nextDouble() - 0.5) * 0.1;
        _simulatedDiskUsage = _simulatedDiskUsage.clamp(100.0, _totalDisk * 0.95);
      }

      final batteryInfo = await _getBatteryInfo();
      final temperature = 40.0 + _random.nextDouble() * 30; // 40-70°C
      final osVersion = await _getOsVersion();
      final devices = await _getConnectedDevices();
      final uptime = DateTime.now().difference(_startTime).inSeconds.toDouble();

      final newInfo = SystemInfo(
        cpuUsage: _simulatedCpuUsage,
        ramUsage: _simulatedRamUsage,
        ramTotal: _totalRam,
        gpuUsage: _simulatedGpuUsage,
        networkUpload: _simulatedNetworkUp,
        networkDownload: _simulatedNetworkDown,
        batteryLevel: batteryInfo['level']!.toInt(),
        isCharging: batteryInfo['charging']! > 0,
        temperature: temperature,
        osVersion: osVersion,
        connectedDevices: devices,
        timestamp: DateTime.now(),
        // Extended system information
        computerName: _cachedComputerName ?? 'Unknown',
        userName: _cachedUserName ?? 'Unknown',
        totalProcesses: _simulatedProcesses,
        diskUsage: _simulatedDiskUsage,
        diskTotal: _totalDisk,
        cpuModel: _cachedCpuModel ?? 'Unknown CPU',
        cpuCores: 8,
        gpuModel: _cachedGpuModel ?? 'Unknown GPU',
        uptime: uptime,
        architecture: Platform.isWindows ? 'x64' : Platform.operatingSystem,
        screenWidth: 1920,
        screenHeight: 1080,
        runningProcesses: _generateRunningProcesses(),
      );

      _currentInfo = newInfo;
      _history.add(newInfo);
      
      // Keep only last 60 entries (1 minute of data)
      if (_history.length > 60) {
        _history.removeAt(0);
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating system info: $e');
      }
    }
  }

  Future<Map<String, double>> _getBatteryInfo() async {
    try {
      final battery = Battery();
      final level = await battery.batteryLevel;
      final state = await battery.batteryState;
      
      return {
        'level': level.toDouble(),
        'charging': state == BatteryState.charging ? 1.0 : 0.0,
      };
    } catch (e) {
      return {'level': 85.0, 'charging': 0.0};
    }
  }

  Future<String> _getOsVersion() async {
    try {
      if (Platform.isWindows) {
        final deviceInfo = DeviceInfoPlugin();
        final windowsInfo = await deviceInfo.windowsInfo;
        return '${windowsInfo.productName} ${windowsInfo.displayVersion}';
      } else if (Platform.isLinux) {
        final deviceInfo = DeviceInfoPlugin();
        final linuxInfo = await deviceInfo.linuxInfo;
        return '${linuxInfo.name} ${linuxInfo.version}';
      } else if (Platform.isMacOS) {
        final deviceInfo = DeviceInfoPlugin();
        final macInfo = await deviceInfo.macOsInfo;
        return 'macOS ${macInfo.osRelease}';
      }
      return Platform.operatingSystem;
    } catch (e) {
      return Platform.operatingSystem;
    }
  }

  Future<List<String>> _getConnectedDevices() async {
    try {
      final connectivity = Connectivity();
      final connectivityResult = await connectivity.checkConnectivity();
      
      List<String> devices = [];
      switch (connectivityResult) {
        case ConnectivityResult.wifi:
          devices.add('WiFi');
          break;
        case ConnectivityResult.ethernet:
          devices.add('Ethernet');
          break;
        case ConnectivityResult.mobile:
          devices.add('Mobile Data');
          break;
        case ConnectivityResult.other:
          devices.add('Other');
          break;
        case ConnectivityResult.none:
          // Don't add anything for no connection
          break;
        case ConnectivityResult.bluetooth:
          devices.add('Bluetooth');
          break;
        case ConnectivityResult.vpn:
          devices.add('VPN');
          break;
      }

      return devices.isEmpty ? ['Offline'] : devices;
    } catch (e) {
      return ['Unknown'];
    }
  }

  @override
  void dispose() {
    stopMonitoring();
    super.dispose();
  }
}
