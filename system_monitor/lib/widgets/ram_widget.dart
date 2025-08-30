import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/system_monitor_bloc.dart';
import '../bloc/system_monitor_state.dart';

class RamWidget extends StatelessWidget {
  const RamWidget({super.key});

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
        final usagePercent = currentInfo.ramUsage / currentInfo.ramTotal * 100;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.storage, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'RAM Usage',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Custom Linear Progress Indicator
                Container(
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        height: 24,
                        width: MediaQuery.of(context).size.width * (usagePercent / 100) * 0.7, // Approximate container width
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: _getRamColor(usagePercent),
                        ),
                      ),
                      Center(
                        child: Text(
                          '${usagePercent.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Memory Details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Used',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '${currentInfo.ramUsage.toStringAsFixed(1)} GB',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Total',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '${currentInfo.ramTotal.toStringAsFixed(1)} GB',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Usage bars breakdown
                Column(
                  children: [
                    _buildUsageBar(context, 'Used', usagePercent, _getRamColor(usagePercent)),
                    const SizedBox(height: 4),
                    _buildUsageBar(context, 'Free', (100 - usagePercent).toDouble(), Colors.grey.withOpacity(0.5)),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                Center(
                  child: Text(
                    _getRamStatus(usagePercent),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getRamColor(usagePercent),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUsageBar(BuildContext context, String label, double percent, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.grey.withOpacity(0.2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percent / 100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: color,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 40,
          child: Text(
            '${percent.toStringAsFixed(0)}%',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Color _getRamColor(double usage) {
    if (usage < 50) return Colors.green;
    if (usage < 80) return Colors.orange;
    return Colors.red;
  }

  String _getRamStatus(double usage) {
    if (usage < 50) return 'Optimal';
    if (usage < 80) return 'Moderate Usage';
    return 'High Usage - Consider closing applications';
  }
}
