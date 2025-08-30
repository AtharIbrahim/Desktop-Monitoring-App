import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/system_monitor_bloc.dart';
import '../bloc/system_monitor_state.dart';

class NetworkWidget extends StatelessWidget {
  const NetworkWidget({super.key});

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
                    const Icon(Icons.wifi, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Network',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Upload/Download indicators
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(Icons.upload, color: Colors.green),
                          const SizedBox(height: 4),
                          Text(
                            'Upload',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '${_formatBytes(currentInfo.networkUpload)}/s',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          const Icon(Icons.download, color: Colors.orange),
                          const SizedBox(height: 4),
                          Text(
                            'Download',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '${_formatBytes(currentInfo.networkDownload)}/s',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Connected devices
                Text(
                  'Connected:',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  children: currentInfo.connectedDevices.map((device) {
                    return Chip(
                      label: Text(
                        device,
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: _getDeviceColor(device),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
                
                const SizedBox(height: 8),
                
                if (currentInfo.networkUpload == 0 && currentInfo.networkDownload == 0)
                  Text(
                    'Network monitoring requires platform-specific implementation',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatBytes(double bytes) {
    if (bytes == 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    int i = 0;
    double size = bytes;
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(size < 10 ? 1 : 0)} ${suffixes[i]}';
  }

  Color _getDeviceColor(String device) {
    switch (device.toLowerCase()) {
      case 'wifi':
        return Colors.blue.withOpacity(0.2);
      case 'ethernet':
        return Colors.green.withOpacity(0.2);
      case 'mobile data':
        return Colors.orange.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }
}
