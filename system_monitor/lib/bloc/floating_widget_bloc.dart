import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'floating_widget_event.dart';
import 'floating_widget_state.dart';

class FloatingWidgetBloc extends Bloc<FloatingWidgetEvent, FloatingWidgetState> {
  FloatingWidgetBloc() : super(const FloatingWidgetState()) {
    on<ToggleFloatingWidget>(_onToggleFloatingWidget);
    on<UpdateWidgetPosition>(_onUpdateWidgetPosition);
    on<CloseAllFloatingWidgets>(_onCloseAllFloatingWidgets);
  }

  void _onToggleFloatingWidget(ToggleFloatingWidget event, Emitter<FloatingWidgetState> emit) {
    final newActiveWidgets = Map<String, bool>.from(state.activeWidgets);
    final newPositions = Map<String, Offset>.from(state.widgetPositions);
    
    final isCurrentlyActive = newActiveWidgets[event.widgetType] ?? false;
    newActiveWidgets[event.widgetType] = !isCurrentlyActive;
    
    if (!newActiveWidgets[event.widgetType]!) {
      // Widget is being deactivated, remove its position
      newPositions.remove(event.widgetType);
    } else {
      // Widget is being activated, set default position if not exists
      if (!newPositions.containsKey(event.widgetType)) {
        newPositions[event.widgetType] = state.getWidgetPosition(event.widgetType);
      }
    }
    
    emit(state.copyWith(
      activeWidgets: newActiveWidgets,
      widgetPositions: newPositions,
    ));
  }

  void _onUpdateWidgetPosition(UpdateWidgetPosition event, Emitter<FloatingWidgetState> emit) {
    final newPositions = Map<String, Offset>.from(state.widgetPositions);
    newPositions[event.widgetType] = event.position;
    
    emit(state.copyWith(widgetPositions: newPositions));
  }

  void _onCloseAllFloatingWidgets(CloseAllFloatingWidgets event, Emitter<FloatingWidgetState> emit) {
    emit(const FloatingWidgetState());
  }
}
