import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'system_monitor_event.dart';
import 'system_monitor_state.dart';

class SystemMonitorBloc extends Bloc<SystemMonitorEvent, SystemMonitorState> {
  Timer? _timer;
  List<SystemInfo> _history = [];
  final Random _random = Random();
  
  // Simulated values for demonstration
  double _simulatedCpuUsage = 15.0;
  double _simulatedRamUsage = 4.5;
  final double _totalRam = 16.0;
  double _simulatedGpuUsage = 5.0;
  double _simulatedNetworkUp = 0.0;
  double _simulatedNetworkDown = 0.0;
  double _simulatedDiskUsage = 125.0;
  final double _totalDisk = 500.0;
  int _simulatedProcesses = 150;
  late DateTime _startTime;
  
  // System info cache
  String? _cachedComputerName;
  String? _cachedUserName;
  String? _cachedCpuModel;
  String? _cachedGpuModel;

  SystemMonitorBloc() : super(SystemMonitorInitial()) {
    _startTime = DateTime.now();
    _initializeSystemInfo();
    
    on<StartMonitoring>(_onStartMonitoring);
    on<StopMonitoring>(_onStopMonitoring);
    on<UpdateSystemInfo>(_onUpdateSystemInfo);
    on<ResetHistory>(_onResetHistory);
    
    // Auto-start monitoring
    add(StartMonitoring());
  }

  void _initializeSystemInfo() {
    _cachedComputerName = Platform.environment['COMPUTERNAME'] ?? 'Unknown';
    _cachedUserName = Platform.environment['USERNAME'] ?? 'Unknown';
    _cachedCpuModel = 'Intel Core i7-12700K';
    _cachedGpuModel = 'NVIDIA GeForce RTX 3070';
  }

  void _onStartMonitoring(StartMonitoring event, Emitter<SystemMonitorState> emit) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(UpdateSystemInfo());
    });
    
    // Initial update
    add(UpdateSystemInfo());
  }

  void _onStopMonitoring(StopMonitoring event, Emitter<SystemMonitorState> emit) {
    _timer?.cancel();
    _timer = null;
    
    if (state is SystemMonitorLoaded) {
      final currentState = state as SystemMonitorLoaded;
      emit(currentState.copyWith(isMonitoring: false));
    }
  }

  Future<void> _onUpdateSystemInfo(UpdateSystemInfo event, Emitter<SystemMonitorState> emit) async {
    try {
      // Simulate realistic fluctuations
      _simulatedCpuUsage += (_random.nextDouble() - 0.5) * 10;
      _simulatedCpuUsage = _simulatedCpuUsage.clamp(5.0, 95.0);
      
      _simulatedRamUsage += (_random.nextDouble() - 0.5) * 0.5;
      _simulatedRamUsage = _simulatedRamUsage.clamp(2.0, _totalRam * 0.9);
      
      _simulatedGpuUsage += (_random.nextDouble() - 0.5) * 15;
      _simulatedGpuUsage = _simulatedGpuUsage.clamp(0.0, 85.0);
      
      _simulatedNetworkUp = _random.nextDouble() * 1024 * 1024;
      _simulatedNetworkDown = _random.nextDouble() * 5 * 1024 * 1024;

      _simulatedProcesses += _random.nextInt(5) - 2;
      _simulatedProcesses = _simulatedProcesses.clamp(100, 300);

      if (_random.nextDouble() < 0.1) {
        _simulatedDiskUsage += (_random.nextDouble() - 0.5) * 0.1;
        _simulatedDiskUsage = _simulatedDiskUsage.clamp(100.0, _totalDisk * 0.95);
      }

      final batteryInfo = await _getBatteryInfo();
      final temperature = 40.0 + _random.nextDouble() * 30;
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

      _history.add(newInfo);
      
      // Keep only last 60 entries
      if (_history.length > 60) {
        _history.removeAt(0);
      }

      emit(SystemMonitorLoaded(
        currentInfo: newInfo,
        history: List.from(_history),
        isMonitoring: _timer != null,
      ));
    } catch (e) {
      emit(SystemMonitorError('Error updating system info: $e'));
    }
  }

  void _onResetHistory(ResetHistory event, Emitter<SystemMonitorState> emit) {
    _history.clear();
    if (state is SystemMonitorLoaded) {
      final currentState = state as SystemMonitorLoaded;
      emit(currentState.copyWith(history: []));
    }
  }

  List<String> _generateRunningProcesses() {
    final processes = [
      'chrome.exe', 'explorer.exe', 'winlogon.exe', 'dwm.exe', 'svchost.exe',
      'System', 'Registry', 'audiodg.exe', 'lsass.exe', 'services.exe',
      'conhost.exe', 'SearchFilterHost.exe', 'SearchProtocolHost.exe',
      'dart.exe', 'Code.exe', 'notepad.exe', 'taskmgr.exe', 'Discord.exe',
    ];
    
    final activeProcesses = <String>[];
    final processCount = 10 + _random.nextInt(8);
    
    for (int i = 0; i < processCount; i++) {
      final process = processes[_random.nextInt(processes.length)];
      if (!activeProcesses.contains(process)) {
        activeProcesses.add(process);
      }
    }
    
    return activeProcesses;
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
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
