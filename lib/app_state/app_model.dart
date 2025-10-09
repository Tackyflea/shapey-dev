// notifier that the text typed changed

import 'package:shapey/enums/e_active_tool.dart';

class AppModel {
  const AppModel({
    this.name,
    this.age = 0,
    this.activeTool = ActiveTool.selectTool,
  });

  final String? name;
  final int age;
  final ActiveTool activeTool;

  AppModel copyWith({String? name, int? age, ActiveTool? activeTool}) {
    return AppModel(
      name: name ?? this.name,
      age: age ?? this.age,
      activeTool: activeTool ?? this.activeTool,
    );
  }
}
