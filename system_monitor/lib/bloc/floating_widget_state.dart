import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FloatingWidgetState extends Equatable {
  final Map<String, bool> activeWidgets;
  final Map<String, Offset> widgetPositions;

  const FloatingWidgetState({
    this.activeWidgets = const {},
    this.widgetPositions = const {},
  });

  @override
  List<Object> get props => [activeWidgets, widgetPositions];

  FloatingWidgetState copyWith({
    Map<String, bool>? activeWidgets,
    Map<String, Offset>? widgetPositions,
  }) {
    return FloatingWidgetState(
      activeWidgets: activeWidgets ?? this.activeWidgets,
      widgetPositions: widgetPositions ?? this.widgetPositions,
    );
  }

  bool isWidgetActive(String widgetType) {
    return activeWidgets[widgetType] ?? false;
  }

  Offset getWidgetPosition(String widgetType) {
    return widgetPositions[widgetType] ?? _getDefaultPosition(widgetType);
  }

  Offset _getDefaultPosition(String widgetType) {
    final index = ['cpu', 'ram', 'gpu', 'network', 'battery', 'temperature', 'disk', 'processes']
        .indexOf(widgetType.toLowerCase());
    return Offset(100.0 + (index * 200.0), 100.0 + (index * 50.0));
  }

  List<String> get activeWidgetsList {
    return activeWidgets.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }
}
