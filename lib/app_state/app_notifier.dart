// Notifier to manage a AppModel
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/enums/e_active_tool.dart';

import 'app_model.dart';

class AppNotifier extends Notifier<AppModel> {
  @override
  AppModel build() {
    // initial default data for app
    return const AppModel(
      name: 'Default Name',
      age: 0,
      activeTool: ActiveTool
          .penTool, // starting with pen tool just to make debugging faster
    );
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateTool(ActiveTool activeTool) {
    print("new Tool: " + activeTool.toString());
    state = state.copyWith(activeTool: activeTool);
  }

  void updateAge(int age) {
    state = state.copyWith(age: age);
  }

  String get name => state.name ?? 'Default Name';
  int get age => state.age ?? 0;
  ActiveTool get activeTool => state.activeTool ?? ActiveTool.selectTool;
}

// the provider
final appNotifier = NotifierProvider<AppNotifier, AppModel>(AppNotifier.new);
