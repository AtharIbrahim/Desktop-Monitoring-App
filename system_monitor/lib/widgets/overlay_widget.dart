import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/system_monitor_bloc.dart';
import '../bloc/system_monitor_state.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_state.dart';

class OverlayWidget extends StatefulWidget {
  const OverlayWidget({super.key});

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  bool _isMinimized = false;
  Offset _position = const Offset(100, 100);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        if (!settingsState.isMinimalMode) {
          return const SizedBox.shrink();
        }

        return BlocBuilder<SystemMonitorBloc, SystemMonitorState>(
          builder: (context, systemState) {
            if (systemState is! SystemMonitorLoaded) {
              return const SizedBox.shrink();
            }

            return Positioned(
              left: _position.dx,
              top: _position.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _position += details.delta;
                  });
                },
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                      ),
                    ),
                    child: _isMinimized
                        ? _buildMinimizedView(systemState, settingsState)
                        : _buildExpandedView(systemState, settingsState),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMinimizedView(SystemMonitorLoaded systemState, SettingsState settingsState) {
    final currentInfo = systemState.currentInfo;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (settingsState.showCpuWidget)
          _buildMiniStat('CPU', '${currentInfo.cpuUsage.toStringAsFixed(0)}%', Colors.blue),
        if (settingsState.showRamWidget)
          _buildMiniStat('RAM', '${(currentInfo.ramUsage / currentInfo.ramTotal * 100).toStringAsFixed(0)}%', Colors.green),
        if (settingsState.showGpuWidget)
          _buildMiniStat('GPU', '${currentInfo.gpuUsage.toStringAsFixed(0)}%', Colors.purple),
        IconButton(
          icon: const Icon(Icons.expand_more, size: 16),
          onPressed: () => setState(() => _isMinimized = false),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildExpandedView(SystemMonitorLoaded systemState, SettingsState settingsState) {
    final currentInfo = systemState.currentInfo;

    return SizedBox(
      width: 250,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              const Icon(Icons.computer, size: 16),
              const SizedBox(width: 4),
              const Text('System Monitor', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.minimize, size: 16),
                onPressed: () => setState(() => _isMinimized = true),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          
          const Divider(height: 8),
          
          // System stats
          if (settingsState.showCpuWidget)
            _buildStatRow('CPU', currentInfo.cpuUsage, '%', Colors.blue),
          
          if (settingsState.showRamWidget)
            _buildStatRow('RAM', currentInfo.ramUsage / currentInfo.ramTotal * 100, '%', Colors.green),
          
          if (settingsState.showGpuWidget)
            _buildStatRow('GPU', currentInfo.gpuUsage, '%', Colors.purple),
          
          if (settingsState.showNetworkWidget)
            _buildNetworkRow(currentInfo),
          
          if (settingsState.showBatteryWidget)
            _buildBatteryRow(currentInfo),
          
          if (settingsState.showTemperatureWidget)
            _buildStatRow('Temp', currentInfo.temperature, '°C', _getTemperatureColor(currentInfo.temperature)),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 8)),
          Text(value, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, double value, String unit, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(label, style: const TextStyle(fontSize: 11)),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: label == 'Temp' ? value / 100 : value / 100,
              backgroundColor: Colors.grey.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 35,
            child: Text(
              '${value.toStringAsFixed(0)}$unit',
              style: TextStyle(fontSize: 10, color: color),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkRow(SystemInfo info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          const SizedBox(
            width: 40,
            child: Text('Net', style: TextStyle(fontSize: 11)),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.upload, size: 10, color: Colors.green),
                    const SizedBox(width: 2),
                    Expanded(child: Text(_formatBytes(info.networkUpload), style: const TextStyle(fontSize: 9))),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.download, size: 10, color: Colors.orange),
                    const SizedBox(width: 2),
                    Expanded(child: Text(_formatBytes(info.networkDownload), style: const TextStyle(fontSize: 9))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatteryRow(SystemInfo info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Row(
              children: [
                const Text('Bat', style: TextStyle(fontSize: 11)),
                if (info.isCharging)
                  const Icon(Icons.flash_on, size: 8, color: Colors.yellow),
              ],
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: info.batteryLevel / 100,
              backgroundColor: Colors.grey.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(_getBatteryColor(info.batteryLevel)),
              minHeight: 8,
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 35,
            child: Text(
              '${info.batteryLevel}%',
              style: TextStyle(fontSize: 10, color: _getBatteryColor(info.batteryLevel)),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatBytes(double bytes) {
    if (bytes == 0) return '0 B/s';
    const suffixes = ['B/s', 'KB/s', 'MB/s'];
    int i = 0;
    double size = bytes;
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(0)} ${suffixes[i]}';
  }

  Color _getTemperatureColor(double temp) {
    if (temp < 50) return Colors.blue;
    if (temp < 70) return Colors.green;
    if (temp < 85) return Colors.orange;
    return Colors.red;
  }

  Color _getBatteryColor(int level) {
    if (level >= 60) return Colors.green;
    if (level >= 20) return Colors.orange;
    return Colors.red;
  }
}
