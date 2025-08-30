import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/system_monitor_bloc.dart';
import '../bloc/system_monitor_state.dart';

class TemperatureWidget extends StatelessWidget {
  const TemperatureWidget({super.key});

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
                      Icons.thermostat,
                      color: _getTemperatureColor(currentInfo.temperature),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Temperature',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Temperature Display
                Center(
                  child: Column(
                    children: [
                      // Custom circular temperature indicator
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Stack(
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(
                                value: _getTemperaturePercent(currentInfo.temperature),
                                strokeWidth: 8,
                                backgroundColor: Colors.grey.withOpacity(0.3),
                                valueColor: AlwaysStoppedAnimation<Color>(_getTemperatureColor(currentInfo.temperature)),
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${currentInfo.temperature.toStringAsFixed(0)}°',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Text(
                                    'C',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Temperature status
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getTemperatureColor(currentInfo.temperature).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _getTemperatureColor(currentInfo.temperature).withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          _getTemperatureStatus(currentInfo.temperature),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: _getTemperatureColor(currentInfo.temperature),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Temperature ranges
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTempRange(context, 'Cool', '< 40°C', Colors.blue),
                    _buildTempRange(context, 'Normal', '40-70°C', Colors.green),
                    _buildTempRange(context, 'Hot', '> 70°C', Colors.red),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Temperature bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Temperature Range',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: const LinearGradient(
                          colors: [
                            Colors.blue,
                            Colors.green,
                            Colors.orange,
                            Colors.red,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            left: (currentInfo.temperature / 100) * (MediaQuery.of(context).size.width - 64) * 0.7,
                            top: -2,
                            child: Container(
                              width: 4,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('0°C', style: Theme.of(context).textTheme.bodySmall),
                        Text('100°C', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Center(
                  child: Text(
                    'Simulated temperature data - real sensors require platform-specific implementation',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                if (currentInfo.temperature > 80)
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
                            'High temperature detected! Check cooling system.',
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

  Widget _buildTempRange(BuildContext context, String label, String range, Color color) {
    return Column(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          range,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  double _getTemperaturePercent(double temp) {
    // Map temperature to a 0-1 scale (0°C to 100°C)
    return (temp / 100).clamp(0.0, 1.0);
  }

  Color _getTemperatureColor(double temp) {
    if (temp < 40) return Colors.blue;
    if (temp < 60) return Colors.green;
    if (temp < 80) return Colors.orange;
    return Colors.red;
  }

  String _getTemperatureStatus(double temp) {
    if (temp < 30) return 'Very Cool';
    if (temp < 40) return 'Cool';
    if (temp < 60) return 'Normal';
    if (temp < 80) return 'Warm';
    if (temp < 90) return 'Hot';
    return 'Critical';
  }
}
