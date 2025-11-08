import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_commands.dart';
import 'package:shapey/app_state/app_model.dart';
import 'package:shapey/app_state/file_model.dart';

// (History-able) Highight the current layer IF not already
void action_highlightLayer(WidgetRef ref, FileLayer layer) {
  // ignore if already active
  if (layer.isMultiSelectActive()) {
    return;
  }
  // print("${DateTime.now().toIso8601String()} Listener Tap");
  final fileModel = ref.read(fileNotifier.notifier);
  final appNotifierInstance = ref.read(appNotifier.notifier);
  final isShiftDown = appNotifierInstance.isShiftDown;
  final appCommandHistory = appNotifierInstance.appCommandHistory;
  //  if you let go of shift, reset layer highliting

  // hightlight layer
  appCommandHistory.executeCommand(
    SetMultiSelectActiveCommand(fileModel, layer.guid(), true, isShiftDown),
  );
}

void action_add_keyframes(WidgetRef ref, FileLayer layer, Set<int> Keys) {
  ref
      .read(appNotifier.select((s) => s.appCommandHistory))
      .executeCommand(
        AddKeyFramesCommand(ref.read(fileNotifier.notifier), layer, Keys),
      );
}

void action_remove_keyframes(WidgetRef ref, FileLayer layer, Set<int> Keys) {
  ref
      .read(appNotifier.select((s) => s.appCommandHistory))
      .executeCommand(
        RemoveKeyFramesCommand(ref.read(fileNotifier.notifier), layer, Keys),
      );
}
