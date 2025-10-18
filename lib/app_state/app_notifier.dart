// Notifier to manage a AppModel
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_history.dart';
import 'package:shapey/enums/e_active_tool.dart';

import 'app_model.dart';

class AppNotifier extends Notifier<AppModel> {
  @override
  AppModel build() {
    // initial default data for app
    return AppModel(
      name: 'Default Name',
      age: 0,
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

  void updateAge(int age) {
    state = state.copyWith(age: age);
  }

  String get name => state.name ?? 'Default Name';
  int get age => state.age;
  ActiveTool get activeTool => state.activeTool;
}

// the provider
final appNotifier = NotifierProvider<AppNotifier, AppModel>(AppNotifier.new);
