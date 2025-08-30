import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_state.dart';
import '../bloc/settings_event.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Appearance Section
              _buildSectionHeader(context, 'Appearance'),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      subtitle: const Text('Use dark theme'),
                      value: settingsState.isDarkMode,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(ToggleDarkMode());
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Minimal Mode'),
                      subtitle: const Text('Show only essential widgets'),
                      value: settingsState.isMinimalMode,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(ToggleMinimalMode());
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Widget Visibility Section
              _buildSectionHeader(context, 'Widget Visibility'),
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text('CPU Widget'),
                      subtitle: const Text('Show CPU usage monitoring'),
                      value: settingsState.showCpuWidget,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(ToggleWidgetVisibility('cpu'));
                      },
                    ),
                    SwitchListTile(
                      title: const Text('RAM Widget'),
                      subtitle: const Text('Show memory usage monitoring'),
                      value: settingsState.showRamWidget,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(ToggleWidgetVisibility('ram'));
                      },
                    ),
                    SwitchListTile(
                      title: const Text('GPU Widget'),
                      subtitle: const Text('Show graphics card monitoring'),
                      value: settingsState.showGpuWidget,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(ToggleWidgetVisibility('gpu'));
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Network Widget'),
                      subtitle: const Text('Show network activity monitoring'),
                      value: settingsState.showNetworkWidget,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(ToggleWidgetVisibility('network'));
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Battery Widget'),
                      subtitle: const Text('Show battery status monitoring'),
                      value: settingsState.showBatteryWidget,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(ToggleWidgetVisibility('battery'));
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Temperature Widget'),
                      subtitle: const Text('Show temperature monitoring'),
                      value: settingsState.showTemperatureWidget,
                      onChanged: (value) {
                        context.read<SettingsBloc>().add(ToggleWidgetVisibility('temperature'));
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Performance Section
              _buildSectionHeader(context, 'Performance'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Refresh Rate'),
                      subtitle: Text('${settingsState.refreshRate.toStringAsFixed(1)} seconds'),
                      trailing: SizedBox(
                        width: 120,
                        child: Slider(
                          value: settingsState.refreshRate,
                          min: 0.5,
                          max: 5.0,
                          divisions: 9,
                          label: '${settingsState.refreshRate.toStringAsFixed(1)}s',
                          onChanged: (value) {
                            context.read<SettingsBloc>().add(UpdateRefreshRate(value));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Actions Section
              _buildSectionHeader(context, 'Actions'),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Reset to Defaults'),
                      subtitle: const Text('Restore all settings to default values'),
                      trailing: const Icon(Icons.restore),
                      onTap: () => _showResetDialog(context),
                    ),
                    ListTile(
                      title: const Text('About'),
                      subtitle: const Text('System Monitor v1.0.0'),
                      trailing: const Icon(Icons.info_outline),
                      onTap: () => _showAboutDialog(context),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reset Settings'),
          content: const Text(
            'Are you sure you want to reset all settings to their default values? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<SettingsBloc>().add(ResetSettings());
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings have been reset to defaults'),
                  ),
                );
              },
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'System Monitor',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.computer, size: 64),
      children: [
        const Text('A comprehensive desktop system monitoring application.'),
        const SizedBox(height: 16),
        const Text('Features:'),
        const Text('• Real-time CPU, RAM, GPU monitoring'),
        const Text('• Network activity tracking'),
        const Text('• Battery status monitoring'),
        const Text('• Temperature monitoring'),
        const Text('• Floating desktop widgets'),
        const Text('• Dark/Light theme support'),
        const Text('• Customizable refresh rates'),
      ],
    );
  }
}
