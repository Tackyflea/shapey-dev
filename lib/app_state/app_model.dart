import 'package:shapey/app_state/app_history.dart';
import 'package:shapey/enums/e_active_tool.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Controls the entire app status
class AppModel {
  const AppModel({
    this.name,
    this.stateChange = 0,
    this.activeTool = ActiveTool
        .penTool, // starting with pen tool just to make debugging faster
    required this.appCommandHistory,
  });

  final String? name;
  final int stateChange; // counters up to indicate a state changed
  final ActiveTool activeTool; // which tool the user last picked
  final AppCommandInvoker appCommandHistory;
  AppModel copyWith({
    int? stateChange,
    String? name,
    int? age,
    ActiveTool? activeTool,
  }) {
    return AppModel(
      stateChange: stateChange ?? this.stateChange,
      name: name ?? this.name,
      activeTool: activeTool ?? this.activeTool,
      appCommandHistory: appCommandHistory,
    );
  }
}

class AppNotifier extends Notifier<AppModel> {
  @override
  AppModel build() {
    debugPrint("app model innitialized");
    // initial default data for app
    return AppModel(
      name: 'Default Name',
      appCommandHistory: AppCommandInvoker(),
    );
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateTool(ActiveTool activeTool) {
    debugPrint("new Tool: $activeTool");
    state = state.copyWith(activeTool: activeTool);
  }

  String get name => state.name ?? 'Default Name';
  ActiveTool get activeTool => state.activeTool;
  //TODO, IDK IF WE NEED STATE CHANGED,
  // THIS IS PURELY SO WE REFRESH CANVAS ON UNDO. Might not need it.
  void stateChanged() {
    state = state.copyWith(stateChange: state.stateChange + 1);
  }
}

// the provider
final appNotifier = NotifierProvider<AppNotifier, AppModel>(AppNotifier.new);
