import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/system_monitor_bloc.dart';
import '../bloc/system_monitor_state.dart';

class SystemInfoWidget extends StatelessWidget {
  const SystemInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SystemMonitorBloc, SystemMonitorState>(
      builder: (context, state) {
        if (state is SystemMonitorLoaded) {
          final info = state.currentInfo;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'Extended System Information',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // System Identity
                  _buildInfoSection(
                    'System Identity',
                    [
                      _buildInfoRow('Computer Name', info.computerName),
                      _buildInfoRow('User Name', info.userName),
                      _buildInfoRow('Architecture', info.architecture),
                      _buildInfoRow('Operating System', info.osVersion),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // System Status
                  _buildInfoSection(
                    'System Status',
                    [
                      _buildInfoRow('Running Processes', '${info.totalProcesses}'),
                      _buildInfoRow('System Uptime', _formatUptime(info.uptime)),
                      _buildInfoRow('System Temperature', '${info.temperature.toStringAsFixed(1)}°C'),
                      _buildInfoRow('Battery Level', '${info.batteryLevel}%'),
                      _buildInfoRow('Battery Status', info.isCharging ? 'Charging' : 'Not Charging'),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Current Usage
                  _buildInfoSection(
                    'Current Resource Usage',
                    [
                      _buildUsageRow('CPU Usage', info.cpuUsage, '%', Colors.blue),
                      _buildUsageRow('RAM Usage', (info.ramUsage / info.ramTotal * 100), '%', Colors.green),
                      _buildUsageRow('GPU Usage', info.gpuUsage, '%', Colors.purple),
                      _buildUsageRow('Disk Usage', (info.diskUsage / info.diskTotal * 100), '%', Colors.amber),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Running Processes
                  _buildInfoSection(
                    'Top Running Processes',
                    info.runningProcesses.take(8).map((process) => 
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            const Icon(Icons.circle, size: 8, color: Colors.green),
                            const SizedBox(width: 8),
                            Text(process, style: const TextStyle(fontFamily: 'monospace')),
                          ],
                        ),
                      ),
                    ).toList(),
                  ),
                ],
              ),
            ),
          );
        }
        
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 8),
                Text('Loading system information...'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              '$label:',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageRow(String label, double value, String unit, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: Text(
              '$label:',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Text(
                  '${value.toStringAsFixed(1)}$unit',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: value > 80 ? Colors.red : value > 60 ? Colors.orange : color,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: LinearProgressIndicator(
                    value: value / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      value > 80 ? Colors.red : value > 60 ? Colors.orange : color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatUptime(double uptimeSeconds) {
    final duration = Duration(seconds: uptimeSeconds.toInt());
    
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h ${duration.inMinutes % 60}m';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m ${duration.inSeconds % 60}s';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
