import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/system_monitor_bloc.dart';
import '../bloc/system_monitor_state.dart';

class BatteryWidget extends StatelessWidget {
  const BatteryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SystemMonitorBloc, SystemMonitorState>(
      builder: (context, state) {
        if (state is! SystemMonitorLoaded) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final currentInfo = state.currentInfo;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getBatteryIcon(currentInfo.batteryLevel, currentInfo.isCharging),
                      color: _getBatteryColor(currentInfo.batteryLevel),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Battery',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (currentInfo.isCharging)
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(Icons.flash_on, color: Colors.yellow, size: 16),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Custom Battery Level Indicator
                Container(
                  height: 28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        height: 28,
                        width: (MediaQuery.of(context).size.width - 64) * (currentInfo.batteryLevel / 100) * 0.8, // Approximate container width
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: LinearGradient(
                            colors: [
                              _getBatteryColor(currentInfo.batteryLevel).withOpacity(0.8),
                              _getBatteryColor(currentInfo.batteryLevel),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          '${currentInfo.batteryLevel}%',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Battery Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Row(
                          children: [
                            Icon(
                              currentInfo.isCharging ? Icons.battery_charging_full : Icons.battery_std,
                              size: 16,
                              color: currentInfo.isCharging ? Colors.green : Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              currentInfo.isCharging ? 'Charging' : 'Discharging',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: currentInfo.isCharging ? Colors.green : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Level',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          _getBatteryStatus(currentInfo.batteryLevel),
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: _getBatteryColor(currentInfo.batteryLevel),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Battery Health Indicator
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getBatteryColor(currentInfo.batteryLevel).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: _getBatteryColor(currentInfo.batteryLevel).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getBatteryHealthIcon(currentInfo.batteryLevel),
                        size: 16,
                        color: _getBatteryColor(currentInfo.batteryLevel),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getBatteryHealthText(currentInfo.batteryLevel, currentInfo.isCharging),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getBatteryColor(currentInfo.batteryLevel),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                if (currentInfo.batteryLevel < 20 && !currentInfo.isCharging)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Low battery! Consider charging soon.',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _getBatteryIcon(int level, bool isCharging) {
    if (isCharging) return Icons.battery_charging_full;
    
    if (level >= 90) return Icons.battery_full;
    if (level >= 60) return Icons.battery_5_bar;
    if (level >= 40) return Icons.battery_3_bar;
    if (level >= 20) return Icons.battery_2_bar;
    return Icons.battery_1_bar;
  }

  IconData _getBatteryHealthIcon(int level) {
    if (level >= 60) return Icons.check_circle;
    if (level >= 20) return Icons.warning;
    return Icons.error;
  }

  Color _getBatteryColor(int level) {
    if (level >= 60) return Colors.green;
    if (level >= 20) return Colors.orange;
    return Colors.red;
  }

  String _getBatteryStatus(int level) {
    if (level >= 80) return 'Excellent';
    if (level >= 60) return 'Good';
    if (level >= 40) return 'Fair';
    if (level >= 20) return 'Low';
    return 'Critical';
  }

  String _getBatteryHealthText(int level, bool isCharging) {
    if (isCharging) {
      return 'Battery is charging normally';
    }
    if (level >= 60) return 'Battery health is good';
    if (level >= 20) return 'Consider charging soon';
    return 'Battery critically low';
  }
}
