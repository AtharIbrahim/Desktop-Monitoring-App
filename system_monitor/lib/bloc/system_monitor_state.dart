import 'package:equatable/equatable.dart';

class SystemInfo extends Equatable {
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

  const SystemInfo({
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

  @override
  List<Object> get props => [
        cpuUsage,
        ramUsage,
        ramTotal,
        gpuUsage,
        networkUpload,
        networkDownload,
        batteryLevel,
        isCharging,
        temperature,
        osVersion,
        connectedDevices,
        timestamp,
        computerName,
        userName,
        totalProcesses,
        diskUsage,
        diskTotal,
        cpuModel,
        cpuCores,
        gpuModel,
        uptime,
        architecture,
        screenWidth,
        screenHeight,
        runningProcesses,
      ];
}

abstract class SystemMonitorState extends Equatable {
  const SystemMonitorState();

  @override
  List<Object?> get props => [];
}

class SystemMonitorInitial extends SystemMonitorState {}

class SystemMonitorLoading extends SystemMonitorState {}

class SystemMonitorLoaded extends SystemMonitorState {
  final SystemInfo currentInfo;
  final List<SystemInfo> history;
  final bool isMonitoring;

  const SystemMonitorLoaded({
    required this.currentInfo,
    required this.history,
    required this.isMonitoring,
  });

  @override
  List<Object> get props => [currentInfo, history, isMonitoring];

  SystemMonitorLoaded copyWith({
    SystemInfo? currentInfo,
    List<SystemInfo>? history,
    bool? isMonitoring,
  }) {
    return SystemMonitorLoaded(
      currentInfo: currentInfo ?? this.currentInfo,
      history: history ?? this.history,
      isMonitoring: isMonitoring ?? this.isMonitoring,
    );
  }
}

class SystemMonitorError extends SystemMonitorState {
  final String message;

  const SystemMonitorError(this.message);

  @override
  List<Object> get props => [message];
}
