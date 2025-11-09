import 'package:shapey/app_state/app_history.dart';
import 'package:shapey/enums/e_active_tool.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Controls the entire app status
class AppModel {
  const AppModel({
    this.name,
    this.activeLayer,
    this.stateChange = 0,
    this.activeFrame = 0, // going programmer style, i might regret this later
    this.activeTool = ActiveTool
        .penTool, // starting with pen tool just to make debugging faster
    this.isShiftDown = false,
    required this.appCommandHistory,
    this.nameHistory = const [],
    this.activeLayerHistory = const [],
    this.activeFrameHistory = const [],
    this.toolHistory = const [],
    this.shiftHistory = const [],
  });

  final String? name;
  final String? activeLayer; // which layer the user last picked
  final int activeFrame;
  final int stateChange; // counters up to indicate a state changed
  final ActiveTool activeTool; // which tool the user last picked
  final AppCommandInvoker appCommandHistory;
  final bool isShiftDown;

  // --- History tracking (mirrors FileNotifier’s layersHistory pattern) ---
  final List<String?> nameHistory;
  final List<String?> activeLayerHistory;
  final List<int> activeFrameHistory;
  final List<ActiveTool> toolHistory;
  final List<bool> shiftHistory;

  AppModel copyWith({
    int? stateChange,
    String? name,
    int? activeFrame,
    String? activeLayer,
    ActiveTool? activeTool,
    bool? isShiftDown,
    List<String?>? nameHistory,
    List<String?>? activeLayerHistory,
    List<int>? activeFrameHistory,
    List<ActiveTool>? toolHistory,
    List<bool>? shiftHistory,
  }) {
    return AppModel(
      name: name ?? this.name,
      activeLayer: activeLayer ?? this.activeLayer,
      stateChange: stateChange ?? this.stateChange,
      activeTool: activeTool ?? this.activeTool,
      activeFrame: activeFrame ?? this.activeFrame,
      appCommandHistory: appCommandHistory,
      isShiftDown: isShiftDown ?? this.isShiftDown,
      nameHistory: nameHistory ?? this.nameHistory,
      activeLayerHistory: activeLayerHistory ?? this.activeLayerHistory,
      activeFrameHistory: activeFrameHistory ?? this.activeFrameHistory,
      toolHistory: toolHistory ?? this.toolHistory,
      shiftHistory: shiftHistory ?? this.shiftHistory,
    );
  }
}

class AppNotifier extends Notifier<AppModel> {
  @override
  AppModel build() {
    debugPrint("app model initialized");
    // initial default data for app
    return AppModel(
      name: 'Default Name',
      appCommandHistory: AppCommandInvoker(),
    );
  }

  // === Track changes to name (with history) ===
  void updateName(String name) {
    final current = state;
    final updatedHistory = [...current.nameHistory, current.name];
    state = current.copyWith(name: name, nameHistory: updatedHistory);
  }

  // For undo/redo (does NOT record new history)
  void restoreNameWithoutHistory(String? name) {
    state = state.copyWith(name: name);
  }

  // === Track changes to active layer ===
  void updateActiveLayer(String? newGUID) {
    final current = state;
    final updatedHistory = [...current.activeLayerHistory, current.activeLayer];
    state = current.copyWith(
      activeLayer: newGUID,
      activeLayerHistory: updatedHistory,
    );
  }

  void restoreActiveLayerWithoutHistory(String? layer) {
    state = state.copyWith(activeLayer: layer);
  }

  // === Track changes to active frame ===
  void updateActiveFrame(int newFrame) {
    final current = state;
    final updatedHistory = [...current.activeFrameHistory, current.activeFrame];
    state = current.copyWith(
      activeFrame: newFrame,
      activeFrameHistory: updatedHistory,
    );
  }

  void restoreActiveFrameWithoutHistory(int frame) {
    state = state.copyWith(activeFrame: frame);
  }

  // === Track changes to active tool ===
  void updateTool(ActiveTool activeTool) {
    final current = state;
    final updatedHistory = [...current.toolHistory, current.activeTool];
    debugPrint("new Tool: $activeTool");
    state = current.copyWith(
      activeTool: activeTool,
      toolHistory: updatedHistory,
    );
  }

  void restoreToolWithoutHistory(ActiveTool tool) {
    state = state.copyWith(activeTool: tool);
  }

  // === Track changes to shift key state ===
  void setShiftDown(bool value) {
    final current = state;
    final updatedHistory = [...current.shiftHistory, current.isShiftDown];
    state = current.copyWith(isShiftDown: value, shiftHistory: updatedHistory);
  }

  void restoreShiftDownWithoutHistory(bool value) {
    state = state.copyWith(isShiftDown: value);
  }

  // === Accessors ===
  String get name => state.name ?? 'Default Name';
  ActiveTool get activeTool => state.activeTool;
  bool get isShiftDown => state.isShiftDown;
  AppCommandInvoker get appCommandHistory => state.appCommandHistory;
  String? get activeLayer => state.activeLayer;
  int get activeFrame => state.activeFrame;

  // TODO: IDK IF WE NEED STATE CHANGED,
  // THIS IS PURELY SO WE REFRESH CANVAS ON UNDO. Might not need it.
  void stateChanged() {
    state = state.copyWith(stateChange: state.stateChange + 1);
  }
}

// the provider
final appNotifier = NotifierProvider<AppNotifier, AppModel>(AppNotifier.new);
