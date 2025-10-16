// notifier that the text typed changed

import 'package:shapey/app_state/app_history.dart';
import 'package:shapey/enums/e_active_tool.dart';

class AppModel {
  const AppModel({
    this.name,
    this.age = 0,
    this.activeTool = ActiveTool
        .penTool, // starting with pen tool just to make debugging faster
    required this.appCommandHistory,
  });

  final String? name;
  final int age;
  final ActiveTool activeTool;
  final AppCommandInvoker appCommandHistory;
  AppModel copyWith({String? name, int? age, ActiveTool? activeTool}) {
    return AppModel(
      name: name ?? this.name,
      age: age ?? this.age,
      activeTool: activeTool ?? this.activeTool,
      appCommandHistory: appCommandHistory,
    );
  }
}
