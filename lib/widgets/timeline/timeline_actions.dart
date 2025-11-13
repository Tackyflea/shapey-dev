import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_commands.dart';
import 'package:shapey/app_state/app_model.dart';
import 'package:shapey/app_state/file_model.dart';
import 'package:shapey/shape_canvas.dart';
import 'package:vector_math/vector_math.dart';

// (History-able) Highight the current layer IF not already
void action_highlightLayer(WidgetRef ref, FileLayer layer) {
  // ignore if already active
  if (layer.isMultiSelectActive()) {
    return;
  }
  // print("${DateTime.now().toIso8601String()} Listener Tap");
  final fileModel = ref.read(fileNotifier.notifier);
  final appModel = ref.read(appNotifier.notifier);
  final isShiftDown = appModel.isShiftDown;
  final appCommandHistory = appModel.appCommandHistory;
  //  if you let go of shift, reset layer highliting

  // hightlight layer
  appCommandHistory.executeCommand(
    SetMultiSelectActiveCommand(
      fileModel,
      appModel,
      layer.guid(),
      true,
      isShiftDown,
    ),
  );
}

void action_add_keyframes(WidgetRef ref, FileLayer layer, Set<int> Keys) {
  ref
      .read(appNotifier.select((s) => s.appCommandHistory))
      .executeCommand(
        AddKeyFramesCommand(ref.read(fileNotifier.notifier), layer, Keys),
      );
}

void action_drawy_pen(
  ShapeCanvasState shapeCanvasState,
  WidgetRef ref,
  Vector2 MousePosition,
  String layeGuid,
  int currentFrame,
) {
  ref
      .read(appNotifier.select((s) => s.appCommandHistory))
      .executeCommand(
        DrawyPenCommand(
          shapeCanvasState,
          ref.read(fileNotifier.notifier),
          MousePosition,
          currentFrame,
          layeGuid,
        ),
      );
}

void action_remove_keyframes(WidgetRef ref, FileLayer layer, Set<int> Keys) {
  ref
      .read(appNotifier.select((s) => s.appCommandHistory))
      .executeCommand(
        RemoveKeyFramesCommand(ref.read(fileNotifier.notifier), layer, Keys),
      );
}

void action_set_frame(WidgetRef ref, int newFrame) {
  // ref
  //     .read(appNotifier.select((s) => s.appCommandHistory))
  //     .executeCommand(
  //       SetActiveFrameCommand(ref.read(appNotifier.notifier), newFrame),
  //     );
  // Design choice , for now --
  // changing frame doesnt get written in history, as that might get huge
  ref.read(appNotifier.notifier).restoreActiveFrameWithoutHistory(newFrame);
}
