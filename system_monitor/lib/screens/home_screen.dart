import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/system_monitor_bloc.dart';
import '../bloc/system_monitor_state.dart';
import '../bloc/system_monitor_event.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_state.dart';
import '../bloc/settings_event.dart';
import '../bloc/floating_widget_bloc.dart';
import '../bloc/floating_widget_state.dart';
import '../bloc/floating_widget_event.dart';
import '../widgets/cpu_widget.dart';
import '../widgets/ram_widget.dart';
import '../widgets/gpu_widget.dart';
import '../widgets/network_widget.dart';
import '../widgets/battery_widget.dart';
import '../widgets/temperature_widget.dart';
import '../widgets/system_info_widget.dart';
import '../widgets/overlay_widget.dart';
import '../widgets/floating_widget_manager.dart';
import '../screens/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Monitor'),
        actions: [
          BlocBuilder<SystemMonitorBloc, SystemMonitorState>(
            builder: (context, state) {
              final isMonitoring = state is SystemMonitorLoaded ? state.isMonitoring : false;
              return IconButton(
                icon: Icon(isMonitoring ? Icons.pause : Icons.play_arrow),
                onPressed: () {
                  if (isMonitoring) {
                    context.read<SystemMonitorBloc>().add(StopMonitoring());
                  } else {
                    context.read<SystemMonitorBloc>().add(StartMonitoring());
                  }
                },
              );
            },
          ),
          BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, settingsState) {
              return IconButton(
                icon: Icon(settingsState.isMinimalMode ? Icons.fullscreen_exit : Icons.fullscreen),
                tooltip: settingsState.isMinimalMode ? 'Exit Minimal Mode' : 'Enter Minimal Mode',
                onPressed: () {
                  context.read<SettingsBloc>().add(ToggleMinimalMode());
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          BlocBuilder<SystemMonitorBloc, SystemMonitorState>(
            builder: (context, systemState) {
              return BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, settingsState) {
                  if (systemState is! SystemMonitorLoaded) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Initializing system monitor...'),
                        ],
                      ),
                    );
                  }

                  if (settingsState.isMinimalMode) {
                    return _buildMinimalModeInfo(context);
                  }

                  return _buildFullView(context, systemState, settingsState);
                },
              );
            },
          ),
          
          // Overlay widget for minimal mode
          const OverlayWidget(),
          
          // Floating widget overlay
          const FloatingWidgetOverlay(),
        ],
      ),
    );
  }

  Widget _buildMinimalModeInfo(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(32),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.dashboard, size: 64, color: Colors.blue),
              const SizedBox(height: 16),
              Text(
                'Minimal Mode Active',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'System monitor is running in minimal mode.\nLook for the floating widget on your screen.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'You can drag the widget around and minimize/expand it.\nUse the settings to choose which metrics to display.',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<SettingsBloc>().add(ToggleMinimalMode());
                },
                icon: const Icon(Icons.fullscreen_exit),
                label: const Text('Exit Minimal Mode'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullView(BuildContext context, SystemMonitorLoaded systemState, SettingsState settingsState) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // System Overview
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.computer),
                      const SizedBox(width: 8),
                      Text(
                        'System Overview',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('OS: ${systemState.currentInfo.osVersion}'),
                  Text('Last Updated: ${_formatTime(systemState.currentInfo.timestamp)}'),
                  Text('Connected Devices: ${systemState.currentInfo.connectedDevices.join(', ')}'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        systemState.isMonitoring ? Icons.circle : Icons.circle_outlined,
                        color: systemState.isMonitoring ? Colors.green : Colors.red,
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        systemState.isMonitoring ? 'Monitoring Active' : 'Monitoring Paused',
                        style: TextStyle(
                          color: systemState.isMonitoring ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Floating Widgets Control Panel
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.widgets),
                      const SizedBox(width: 8),
                      Text(
                        'Desktop Widgets',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Click to float widgets on your desktop outside of the app',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFloatingWidgetButton(context, 'CPU', Icons.memory, Colors.blue),
                      _buildFloatingWidgetButton(context, 'RAM', Icons.memory, Colors.green),
                      _buildFloatingWidgetButton(context, 'GPU', Icons.videogame_asset, Colors.purple),
                      _buildFloatingWidgetButton(context, 'Network', Icons.wifi, Colors.cyan),
                      _buildFloatingWidgetButton(context, 'Battery', Icons.battery_std, Colors.green),
                      _buildFloatingWidgetButton(context, 'Temperature', Icons.thermostat, Colors.orange),
                      _buildFloatingWidgetButton(context, 'Disk', Icons.storage, Colors.amber),
                      _buildFloatingWidgetButton(context, 'Processes', Icons.list, Colors.teal),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Performance Metrics Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: _getCrossAxisCount(context),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              if (settingsState.showCpuWidget) const CpuWidget(),
              if (settingsState.showRamWidget) const RamWidget(),
              if (settingsState.showGpuWidget) const GpuWidget(),
              if (settingsState.showNetworkWidget) const NetworkWidget(),
              if (settingsState.showBatteryWidget) const BatteryWidget(),
              if (settingsState.showTemperatureWidget) const TemperatureWidget(),
            ],
          ),
          const SizedBox(height: 16),
          
          // Extended System Information
          const SystemInfoWidget(),
        ],
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 3;
    if (width > 800) return 2;
    return 1;
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}';
  }

  Widget _buildFloatingWidgetButton(BuildContext context, String widgetType, IconData icon, Color color) {
    return BlocBuilder<FloatingWidgetBloc, FloatingWidgetState>(
      builder: (context, state) {
        final isActive = state.isWidgetActive(widgetType.toLowerCase());
        
        return ElevatedButton.icon(
          onPressed: () {
            context.read<FloatingWidgetBloc>().add(ToggleFloatingWidget(widgetType.toLowerCase()));
          },
          icon: Icon(icon, color: isActive ? Colors.white : color),
          label: Text(
            widgetType,
            style: TextStyle(color: isActive ? Colors.white : null),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: isActive ? color : null,
            foregroundColor: isActive ? Colors.white : null,
          ),
        );
      },
    );
  }
}
