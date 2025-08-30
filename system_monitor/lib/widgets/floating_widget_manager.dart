import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/system_monitor_bloc.dart';
import '../bloc/system_monitor_state.dart';
import '../bloc/floating_widget_bloc.dart';
import '../bloc/floating_widget_state.dart';
import '../bloc/floating_widget_event.dart';

class FloatingWidgetOverlay extends StatelessWidget {
  const FloatingWidgetOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FloatingWidgetBloc, FloatingWidgetState>(
      builder: (context, state) {
        return Stack(
          children: state.activeWidgetsList.map((widgetType) {
            return Positioned(
              left: state.getWidgetPosition(widgetType).dx,
              top: state.getWidgetPosition(widgetType).dy,
              child: FloatingWidget(
                widgetType: widgetType,
                onPositionChanged: (newPosition) {
                  context.read<FloatingWidgetBloc>().add(
                    UpdateWidgetPosition(widgetType, newPosition),
                  );
                },
                onClose: () {
                  context.read<FloatingWidgetBloc>().add(
                    ToggleFloatingWidget(widgetType),
                  );
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class FloatingWidget extends StatefulWidget {
  final String widgetType;
  final Function(Offset) onPositionChanged;
  final VoidCallback onClose;

  const FloatingWidget({
    Key? key,
    required this.widgetType,
    required this.onPositionChanged,
    required this.onClose,
  }) : super(key: key);

  @override
  State<FloatingWidget> createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<FloatingWidget> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SystemMonitorBloc, SystemMonitorState>(
      builder: (context, state) {
        if (state is! SystemMonitorLoaded) {
          return const SizedBox();
        }

        final info = state.currentInfo;

        return GestureDetector(
          onPanStart: (details) {
            setState(() {
              _isDragging = true;
            });
          },
          onPanUpdate: (details) {
            final RenderBox renderBox = context.findRenderObject() as RenderBox;
            final position = renderBox.localToGlobal(Offset.zero);
            widget.onPositionChanged(position + details.delta);
          },
          onPanEnd: (details) {
            setState(() {
              _isDragging = false;
            });
          },
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 200,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(_isDragging ? 0.9 : 0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _isDragging ? Colors.blue : Colors.grey[700]!,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: _buildWidgetContent(info),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: widget.onClose,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWidgetContent(SystemInfo info) {
    switch (widget.widgetType.toLowerCase()) {
      case 'cpu':
        return _buildCpuWidget(info);
      case 'ram':
        return _buildRamWidget(info);
      case 'gpu':
        return _buildGpuWidget(info);
      case 'network':
        return _buildNetworkWidget(info);
      case 'battery':
        return _buildBatteryWidget(info);
      case 'temperature':
        return _buildTemperatureWidget(info);
      case 'disk':
        return _buildDiskWidget(info);
      case 'processes':
        return _buildProcessesWidget(info);
      default:
        return _buildSystemInfoWidget(info);
    }
  }

  Widget _buildCpuWidget(SystemInfo info) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.memory, color: Colors.blue, size: 32),
        const SizedBox(height: 8),
        const Text(
          'CPU',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          '${info.cpuUsage.toStringAsFixed(1)}%',
          style: const TextStyle(color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: info.cpuUsage / 100,
          backgroundColor: Colors.grey[800],
          valueColor: AlwaysStoppedAnimation<Color>(
            info.cpuUsage > 80 ? Colors.red : 
            info.cpuUsage > 60 ? Colors.orange : Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          info.cpuModel,
          style: TextStyle(color: Colors.grey[400], fontSize: 10),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildRamWidget(SystemInfo info) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.memory, color: Colors.green, size: 32),
        const SizedBox(height: 8),
        const Text(
          'RAM',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          '${(info.ramUsage / info.ramTotal * 100).toStringAsFixed(1)}%',
          style: const TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          '${info.ramUsage.toStringAsFixed(1)}/${info.ramTotal.toStringAsFixed(1)} GB',
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: info.ramUsage / info.ramTotal,
          backgroundColor: Colors.grey[800],
          valueColor: AlwaysStoppedAnimation<Color>(
            (info.ramUsage / info.ramTotal) > 0.8 ? Colors.red : 
            (info.ramUsage / info.ramTotal) > 0.6 ? Colors.orange : Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildGpuWidget(SystemInfo info) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.videogame_asset, color: Colors.purple, size: 32),
        const SizedBox(height: 8),
        const Text(
          'GPU',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          '${info.gpuUsage.toStringAsFixed(1)}%',
          style: const TextStyle(color: Colors.purple, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: info.gpuUsage / 100,
          backgroundColor: Colors.grey[800],
          valueColor: AlwaysStoppedAnimation<Color>(
            info.gpuUsage > 80 ? Colors.red : 
            info.gpuUsage > 60 ? Colors.orange : Colors.purple,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          info.gpuModel,
          style: TextStyle(color: Colors.grey[400], fontSize: 10),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildNetworkWidget(SystemInfo info) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.wifi, color: Colors.cyan, size: 32),
        const SizedBox(height: 8),
        const Text(
          'Network',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_upward, color: Colors.cyan, size: 16),
            Text(
              '${(info.networkUpload / 1024 / 1024).toStringAsFixed(1)} MB/s',
              style: const TextStyle(color: Colors.cyan, fontSize: 12),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_downward, color: Colors.cyan, size: 16),
            Text(
              '${(info.networkDownload / 1024 / 1024).toStringAsFixed(1)} MB/s',
              style: const TextStyle(color: Colors.cyan, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          info.connectedDevices.join(', '),
          style: TextStyle(color: Colors.grey[400], fontSize: 10),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildBatteryWidget(SystemInfo info) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          info.isCharging ? Icons.battery_charging_full : Icons.battery_std,
          color: info.batteryLevel > 20 ? Colors.green : Colors.red,
          size: 32,
        ),
        const SizedBox(height: 8),
        const Text(
          'Battery',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          '${info.batteryLevel}%',
          style: TextStyle(
            color: info.batteryLevel > 20 ? Colors.green : Colors.red,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (info.isCharging)
          const Text(
            'Charging',
            style: TextStyle(color: Colors.green, fontSize: 12),
          ),
      ],
    );
  }

  Widget _buildTemperatureWidget(SystemInfo info) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.thermostat, color: Colors.orange, size: 32),
        const SizedBox(height: 8),
        const Text(
          'Temperature',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          '${info.temperature.toStringAsFixed(1)}°C',
          style: TextStyle(
            color: info.temperature > 70 ? Colors.red : 
                   info.temperature > 60 ? Colors.orange : Colors.orange,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          info.temperature > 70 ? 'Hot' : info.temperature > 60 ? 'Warm' : 'Normal',
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDiskWidget(SystemInfo info) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.storage, color: Colors.amber, size: 32),
        const SizedBox(height: 8),
        const Text(
          'Disk',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          '${(info.diskUsage / info.diskTotal * 100).toStringAsFixed(1)}%',
          style: const TextStyle(color: Colors.amber, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          '${info.diskUsage.toStringAsFixed(0)}/${info.diskTotal.toStringAsFixed(0)} GB',
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: info.diskUsage / info.diskTotal,
          backgroundColor: Colors.grey[800],
          valueColor: AlwaysStoppedAnimation<Color>(
            (info.diskUsage / info.diskTotal) > 0.9 ? Colors.red : 
            (info.diskUsage / info.diskTotal) > 0.8 ? Colors.orange : Colors.amber,
          ),
        ),
      ],
    );
  }

  Widget _buildProcessesWidget(SystemInfo info) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.list, color: Colors.teal, size: 32),
        const SizedBox(height: 8),
        const Text(
          'Processes',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          '${info.totalProcesses}',
          style: const TextStyle(color: Colors.teal, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Running',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 8),
        Text(
          'Top: ${info.runningProcesses.take(3).join(', ')}',
          style: TextStyle(color: Colors.grey[400], fontSize: 10),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildSystemInfoWidget(SystemInfo info) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.computer, color: Colors.blue, size: 32),
        const SizedBox(height: 8),
        const Text(
          'System Info',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          info.computerName,
          style: const TextStyle(color: Colors.blue, fontSize: 14),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          info.userName,
          style: TextStyle(color: Colors.grey[400], fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          'Uptime: ${(info.uptime / 3600).toStringAsFixed(1)}h',
          style: TextStyle(color: Colors.grey[400], fontSize: 10),
        ),
        Text(
          '${info.architecture} • ${info.screenWidth}x${info.screenHeight}',
          style: TextStyle(color: Colors.grey[400], fontSize: 10),
        ),
      ],
    );
  }
}
