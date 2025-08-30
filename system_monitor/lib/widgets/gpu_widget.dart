import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/system_monitor_bloc.dart';
import '../bloc/system_monitor_state.dart';

class GpuWidget extends StatelessWidget {
  const GpuWidget({super.key});

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
                    const Icon(Icons.videogame_asset, color: Colors.purple),
                    const SizedBox(width: 8),
                    Text(
                      'GPU Usage',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Custom Circular Progress Indicator
                Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(
                            value: currentInfo.gpuUsage / 100,
                            strokeWidth: 6,
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(_getGpuColor(currentInfo.gpuUsage)),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${currentInfo.gpuUsage.toStringAsFixed(1)}%',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                'GPU',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // GPU Performance Indicator
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getGpuColor(currentInfo.gpuUsage).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getGpuColor(currentInfo.gpuUsage).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getGpuIcon(currentInfo.gpuUsage),
                        color: _getGpuColor(currentInfo.gpuUsage),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGpuStatus(currentInfo.gpuUsage),
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: _getGpuColor(currentInfo.gpuUsage),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (currentInfo.gpuUsage == 0)
                              Text(
                                'Simulated data - real GPU monitoring requires platform-specific implementation',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // GPU Utilization Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Utilization',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.grey.withOpacity(0.3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: currentInfo.gpuUsage / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            gradient: LinearGradient(
                              colors: [
                                _getGpuColor(currentInfo.gpuUsage).withOpacity(0.7),
                                _getGpuColor(currentInfo.gpuUsage),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getGpuColor(double usage) {
    if (usage < 30) return Colors.green;
    if (usage < 70) return Colors.orange;
    return Colors.red;
  }

  IconData _getGpuIcon(double usage) {
    if (usage < 30) return Icons.check_circle;
    if (usage < 70) return Icons.warning;
    return Icons.error;
  }

  String _getGpuStatus(double usage) {
    if (usage == 0) return 'Idle / Not Available';
    if (usage < 30) return 'Low Usage';
    if (usage < 70) return 'Moderate Usage';
    return 'High Usage';
  }
}
