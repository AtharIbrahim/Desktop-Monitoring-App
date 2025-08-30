import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<LoadSettings>(_onLoadSettings);
    on<ToggleDarkMode>(_onToggleDarkMode);
    on<ToggleMinimalMode>(_onToggleMinimalMode);
    on<ToggleAlwaysOnTop>(_onToggleAlwaysOnTop);
    on<UpdateRefreshRate>(_onUpdateRefreshRate);
    on<ToggleWidgetVisibility>(_onToggleWidgetVisibility);
    on<ResetSettings>(_onResetSettings);
    
    // Auto-load settings
    add(LoadSettings());
  }

  Future<void> _onLoadSettings(LoadSettings event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(isLoading: true));
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      emit(SettingsState(
        isDarkMode: prefs.getBool('isDarkMode') ?? true,
        isMinimalMode: prefs.getBool('isMinimalMode') ?? false,
        alwaysOnTop: prefs.getBool('alwaysOnTop') ?? false,
        refreshRate: prefs.getDouble('refreshRate') ?? 1.0,
        showCpuWidget: prefs.getBool('showCpuWidget') ?? true,
        showRamWidget: prefs.getBool('showRamWidget') ?? true,
        showGpuWidget: prefs.getBool('showGpuWidget') ?? true,
        showNetworkWidget: prefs.getBool('showNetworkWidget') ?? true,
        showBatteryWidget: prefs.getBool('showBatteryWidget') ?? true,
        showTemperatureWidget: prefs.getBool('showTemperatureWidget') ?? true,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onToggleDarkMode(ToggleDarkMode event, Emitter<SettingsState> emit) async {
    final newValue = !state.isDarkMode;
    emit(state.copyWith(isDarkMode: newValue));
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newValue);
  }

  Future<void> _onToggleMinimalMode(ToggleMinimalMode event, Emitter<SettingsState> emit) async {
    final newValue = !state.isMinimalMode;
    emit(state.copyWith(isMinimalMode: newValue));
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isMinimalMode', newValue);
  }

  Future<void> _onToggleAlwaysOnTop(ToggleAlwaysOnTop event, Emitter<SettingsState> emit) async {
    final newValue = !state.alwaysOnTop;
    emit(state.copyWith(alwaysOnTop: newValue));
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('alwaysOnTop', newValue);
  }

  Future<void> _onUpdateRefreshRate(UpdateRefreshRate event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(refreshRate: event.refreshRate));
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('refreshRate', event.refreshRate);
  }

  Future<void> _onToggleWidgetVisibility(ToggleWidgetVisibility event, Emitter<SettingsState> emit) async {
    SettingsState newState = state;
    
    switch (event.widgetType) {
      case 'cpu':
        newState = state.copyWith(showCpuWidget: !state.showCpuWidget);
        break;
      case 'ram':
        newState = state.copyWith(showRamWidget: !state.showRamWidget);
        break;
      case 'gpu':
        newState = state.copyWith(showGpuWidget: !state.showGpuWidget);
        break;
      case 'network':
        newState = state.copyWith(showNetworkWidget: !state.showNetworkWidget);
        break;
      case 'battery':
        newState = state.copyWith(showBatteryWidget: !state.showBatteryWidget);
        break;
      case 'temperature':
        newState = state.copyWith(showTemperatureWidget: !state.showTemperatureWidget);
        break;
    }
    
    emit(newState);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show${event.widgetType.capitalize()}Widget', 
        _getWidgetVisibility(newState, event.widgetType));
  }

  bool _getWidgetVisibility(SettingsState state, String widgetType) {
    switch (widgetType) {
      case 'cpu':
        return state.showCpuWidget;
      case 'ram':
        return state.showRamWidget;
      case 'gpu':
        return state.showGpuWidget;
      case 'network':
        return state.showNetworkWidget;
      case 'battery':
        return state.showBatteryWidget;
      case 'temperature':
        return state.showTemperatureWidget;
      default:
        return true;
    }
  }

  Future<void> _onResetSettings(ResetSettings event, Emitter<SettingsState> emit) async {
    const defaultState = SettingsState();
    emit(defaultState);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

extension StringCapitalization on String {
  String capitalize() {
    return isEmpty ? this : this[0].toUpperCase() + substring(1);
  }
}
