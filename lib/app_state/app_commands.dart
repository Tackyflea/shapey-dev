import 'package:shapey/app_state/app_history.dart';
import 'package:shapey/app_state/app_model.dart';
import 'package:shapey/app_state/file_model.dart';
import 'package:shapey/utility/drawy/drawy.dart';
import 'package:shapey/utility/drawy/e_interact_type.dart';
import 'package:vector_math/vector_math.dart';

//https://medium.com/@aprayush20/understanding-design-patterns-with-dart-01-chain-of-responsibility-command-pattern-b93da4ea9231
// Execute and undo pen draw
class DrawyPenCommand implements AppCommand {
  final Drawy _receiver;
  final Vector2 newPosition;
  final DrawyInteract _newInteraction;

  DrawyPenCommand(this._receiver, this._newInteraction, this.newPosition);

  @override
  void execute() {
    _receiver.penMode(_newInteraction, newPosition);
  }

  @override
  void undo() {
    _receiver.undoPen();
  }

  @override
  String getTitle() => 'add pen point at $newPosition';
}

class DrawySelectCommand implements AppCommand {
  final Drawy _receiver;
  final Vector2 newPosition;
  final DrawyInteract _newInteraction;

  DrawySelectCommand(this._receiver, this._newInteraction, this.newPosition);

  @override
  void execute() {
    _receiver.selectMode(_newInteraction, newPosition);
  }

  @override
  void undo() {
    _receiver.undoSelect();
  }

  @override
  String getTitle() => 'select pen point at $newPosition';
}

class AddLayerCommand implements AppCommand {
  final FileNotifier fileNotifier;
  final AppNotifier appNotifier;
  late final List<FileLayer> _beforeLayers;
  late final String? _beforeActiveLayer;

  AddLayerCommand(this.fileNotifier, this.appNotifier);

  @override
  void execute() {
    _beforeLayers = [...fileNotifier.layers];
    fileNotifier.clearLayerMultiSelection();
    fileNotifier.addLayer();
    fileNotifier.setMultiSelectActive(fileNotifier.layers.last.guid(), true);
    appNotifier.updateActiveLayer(fileNotifier.layers.last.guid());
  }

  @override
  void undo() {
    fileNotifier.restoreLayersWithoutHistory(_beforeLayers);
    appNotifier.restoreActiveLayerWithoutHistory(_beforeActiveLayer);
  }

  @override
  String getTitle() => 'adding a blank layer';
}

// Set the LAYER to be multi layer active // for shift selecting layers
// if shift isn't down, you'll reset selection
class SetMultiSelectActiveCommand implements AppCommand {
  final FileNotifier fileNotifier;
  final AppNotifier appNotifier;
  final String layerGUID;
  final bool onOff;
  final bool shiftDown;
  late final List<FileLayer> _beforeLayers;
  late String? _beforeActiveLayer;

  SetMultiSelectActiveCommand(
    this.fileNotifier,
    this.appNotifier,
    this.layerGUID,
    this.onOff,
    this.shiftDown,
  );

  @override
  void execute() {
    _beforeLayers = [...fileNotifier.layers];
    _beforeActiveLayer = appNotifier.activeLayer;
    if (shiftDown == false) {
      fileNotifier.clearLayerMultiSelection();
    }
    fileNotifier.setMultiSelectActive(layerGUID, onOff);
    appNotifier.updateActiveLayer(layerGUID);
  }

  @override
  void undo() {
    fileNotifier.restoreLayersWithoutHistory(_beforeLayers);
    appNotifier.restoreActiveLayerWithoutHistory(_beforeActiveLayer);
  }

  @override
  String getTitle() => 'Toggling layer multiSelect $onOff';
}

// CLEAR all LAYER multi selection
class ClearLayerMultiSelectionCommand implements AppCommand {
  final FileNotifier fileNotifier;
  final AppNotifier appNotifier;
  late final List<FileLayer> _beforeLayers;
  late String? _beforeActiveLayer;

  ClearLayerMultiSelectionCommand(this.fileNotifier, this.appNotifier);

  @override
  void execute() {
    _beforeLayers = [...fileNotifier.layers];
    _beforeActiveLayer = appNotifier.activeLayer;
    fileNotifier.clearLayerMultiSelection();
    appNotifier.updateActiveLayer(null);
  }

  @override
  void undo() {
    fileNotifier.restoreLayersWithoutHistory(_beforeLayers);
    appNotifier.restoreActiveLayerWithoutHistory(_beforeActiveLayer);
  }

  @override
  String getTitle() => 'cleared all LAYER multi selection';
}

class RemoveLayerCommand implements AppCommand {
  final FileNotifier notifier;
  final FileLayer layer;
  late final List<FileLayer> _beforeLayers;

  RemoveLayerCommand(this.notifier, this.layer);

  @override
  void execute() {
    _beforeLayers = [...notifier.layers];
    notifier.removeLayer(layer); // normal remove (pushes history)
  }

  @override
  void undo() {
    notifier.restoreLayersWithoutHistory(_beforeLayers);
  }

  @override
  String getTitle() => '${layer.name()} removing layer ';
}

class SetActiveFrameCommand implements AppCommand {
  final AppNotifier appNotifier;
  final int frame;
  late final int _beforeActiveFrame;

  SetActiveFrameCommand(this.appNotifier, this.frame);

  @override
  void execute() {
    _beforeActiveFrame = appNotifier.activeFrame;
    appNotifier.updateActiveFrame(frame);
  }

  @override
  void undo() {
    appNotifier.restoreActiveFrameWithoutHistory(_beforeActiveFrame);
  }

  @override
  String getTitle() => 'setting frame to $frame';
}

class AddKeyFramesCommand implements AppCommand {
  final FileNotifier notifier;
  final FileLayer layer;
  final Set<int> keyFrames;
  late final List<FileLayer> _beforeLayers;

  AddKeyFramesCommand(this.notifier, this.layer, this.keyFrames);

  @override
  void execute() {
    _beforeLayers = [...notifier.layers];
    notifier.addKeyFrames(layer, keyFrames);
  }

  @override
  void undo() {
    notifier.restoreLayersWithoutHistory(_beforeLayers);
  }

  @override
  String getTitle() => '${layer.name()} adding keyframes';
}

class RemoveKeyFramesCommand implements AppCommand {
  final FileNotifier notifier;
  final FileLayer layer;
  final Set<int> keyFrames;
  late final List<FileLayer> _beforeLayers;

  RemoveKeyFramesCommand(this.notifier, this.layer, this.keyFrames);

  @override
  void execute() {
    _beforeLayers = [...notifier.layers];
    notifier.removeKeyFrames(layer, keyFrames);
  }

  @override
  void undo() {
    notifier.restoreLayersWithoutHistory(_beforeLayers);
  }

  @override
  String getTitle() => '${layer.name()} removing keyframes';
}

class AddInitialLayerCommand implements AppCommand {
  final FileNotifier fileNotifier;
  final AppNotifier appNotifier;

  late FileLayer _layer;

  AddInitialLayerCommand(this.fileNotifier, this.appNotifier);

  @override
  void execute() {
    _layer = FileLayer();
    _layer.setName("Layer 0");
    _layer.setMultiSelect(true);
    _layer.setFrameCount((DEFAULT_FPS * DEFAULT_TIMELINE_DURATION).toInt());

    fileNotifier.insertLayer(0, _layer); // history recorded
    appNotifier.updateActiveLayer(_layer.guid()); // history recorded
    appNotifier.updateActiveFrame(0);
  }

  @override
  void undo() {
    // We don't actually want to undo the init state
    // fileNotifier.removeLayer(_layer); // restore previous state
    // appNotifier.updateActiveLayer(null); // restore previous state
  }

  @override
  String getTitle() => "Add initial layer";
}
