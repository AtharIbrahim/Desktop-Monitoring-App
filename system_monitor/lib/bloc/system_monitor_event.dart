import 'package:equatable/equatable.dart';

abstract class SystemMonitorEvent extends Equatable {
  const SystemMonitorEvent();

  @override
  List<Object> get props => [];
}

class StartMonitoring extends SystemMonitorEvent {}

class StopMonitoring extends SystemMonitorEvent {}

class UpdateSystemInfo extends SystemMonitorEvent {}

class ResetHistory extends SystemMonitorEvent {}
