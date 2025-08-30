import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class FloatingWidgetEvent extends Equatable {
  const FloatingWidgetEvent();

  @override
  List<Object> get props => [];
}

class ToggleFloatingWidget extends FloatingWidgetEvent {
  final String widgetType;

  const ToggleFloatingWidget(this.widgetType);

  @override
  List<Object> get props => [widgetType];
}

class UpdateWidgetPosition extends FloatingWidgetEvent {
  final String widgetType;
  final Offset position;

  const UpdateWidgetPosition(this.widgetType, this.position);

  @override
  List<Object> get props => [widgetType, position];
}

class CloseAllFloatingWidgets extends FloatingWidgetEvent {}
