import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final bool isDarkMode;
  final bool isMinimalMode;
  final bool alwaysOnTop;
  final double refreshRate;
  final bool showCpuWidget;
  final bool showRamWidget;
  final bool showGpuWidget;
  final bool showNetworkWidget;
  final bool showBatteryWidget;
  final bool showTemperatureWidget;
  final bool isLoading;

  const SettingsState({
    this.isDarkMode = true,
    this.isMinimalMode = false,
    this.alwaysOnTop = false,
    this.refreshRate = 1.0,
    this.showCpuWidget = true,
    this.showRamWidget = true,
    this.showGpuWidget = true,
    this.showNetworkWidget = true,
    this.showBatteryWidget = true,
    this.showTemperatureWidget = true,
    this.isLoading = false,
  });

  @override
  List<Object> get props => [
        isDarkMode,
        isMinimalMode,
        alwaysOnTop,
        refreshRate,
        showCpuWidget,
        showRamWidget,
        showGpuWidget,
        showNetworkWidget,
        showBatteryWidget,
        showTemperatureWidget,
        isLoading,
      ];

  SettingsState copyWith({
    bool? isDarkMode,
    bool? isMinimalMode,
    bool? alwaysOnTop,
    double? refreshRate,
    bool? showCpuWidget,
    bool? showRamWidget,
    bool? showGpuWidget,
    bool? showNetworkWidget,
    bool? showBatteryWidget,
    bool? showTemperatureWidget,
    bool? isLoading,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isMinimalMode: isMinimalMode ?? this.isMinimalMode,
      alwaysOnTop: alwaysOnTop ?? this.alwaysOnTop,
      refreshRate: refreshRate ?? this.refreshRate,
      showCpuWidget: showCpuWidget ?? this.showCpuWidget,
      showRamWidget: showRamWidget ?? this.showRamWidget,
      showGpuWidget: showGpuWidget ?? this.showGpuWidget,
      showNetworkWidget: showNetworkWidget ?? this.showNetworkWidget,
      showBatteryWidget: showBatteryWidget ?? this.showBatteryWidget,
      showTemperatureWidget: showTemperatureWidget ?? this.showTemperatureWidget,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
