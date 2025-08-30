import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadSettings extends SettingsEvent {}

class ToggleDarkMode extends SettingsEvent {}

class ToggleMinimalMode extends SettingsEvent {}

class ToggleAlwaysOnTop extends SettingsEvent {}

class UpdateRefreshRate extends SettingsEvent {
  final double refreshRate;

  const UpdateRefreshRate(this.refreshRate);

  @override
  List<Object> get props => [refreshRate];
}

class ToggleWidgetVisibility extends SettingsEvent {
  final String widgetType;

  const ToggleWidgetVisibility(this.widgetType);

  @override
  List<Object> get props => [widgetType];
}

class ResetSettings extends SettingsEvent {}
