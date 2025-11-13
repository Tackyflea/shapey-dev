import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_history.dart';
import 'package:shapey/app_state/app_model.dart';
import 'package:shapey/enums/e_active_tool.dart';

class UndoIntent extends Intent {
  const UndoIntent();
}

// triggers undo
class UndoAction extends Action<UndoIntent> {
  UndoAction(this.ref);
  final WidgetRef ref;
  @override
  void invoke(UndoIntent intent) {
    final AppCommandInvoker appCommandHistory = ref.read(
      appNotifier.select((s) => s.appCommandHistory),
    );
    appCommandHistory.undo();
    // to indicate overall state changed
    // To refresh the canvas
    ref.read(appNotifier.notifier).stateChanged();
  }
}

class ToolPenIntent extends Intent {
  const ToolPenIntent();
}

// Switched to Pen
class ToolPenAction extends Action<ToolPenIntent> {
  ToolPenAction(this.ref);
  final WidgetRef ref;
  @override
  void invoke(ToolPenIntent intent) {
    print('pen toool');
    ref.read(appNotifier.notifier).updateTool(ActiveTool.penTool);
  }
}

class ToolSelectIntent extends Intent {
  const ToolSelectIntent();
}

// Switched to Select
class ToolSelectAction extends Action<ToolSelectIntent> {
  ToolSelectAction(this.ref);
  final WidgetRef ref;
  @override
  void invoke(ToolSelectIntent intent) {
    print('select toool');
    ref.read(appNotifier.notifier).updateTool(ActiveTool.selectTool);
  }
}
