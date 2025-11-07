import 'package:shapey/app_state/app_history.dart';
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
  final FileNotifier notifier;
  late final List<FileLayer> _beforeLayers;

  AddLayerCommand(this.notifier);

  @override
  void execute() {
    _beforeLayers = [...notifier.layers];
    notifier.clearLayerMultiSelection();
    notifier.addLayer();
    notifier.setMultiSelectActive(notifier.layers.last.guid(), true);
  }

  @override
  void undo() {
    notifier.restoreLayersWithoutHistory(_beforeLayers);
  }

  @override
  String getTitle() => 'adding a blank layer';
}

// Set the LAYER to be multi layer active // for shift selecting layers
// if shift isn't down, you'll reset selection
class SetMultiSelectActiveCommand implements AppCommand {
  final FileNotifier notifier;
  final String layerGUID;
  final bool onOff;
  final bool shiftDown;
  late final List<FileLayer> _beforeLayers;

  SetMultiSelectActiveCommand(
    this.notifier,
    this.layerGUID,
    this.onOff,
    this.shiftDown,
  );

  @override
  void execute() {
    _beforeLayers = [...notifier.layers];
    if (shiftDown == false) {
      notifier.clearLayerMultiSelection();
    }
    notifier.setMultiSelectActive(layerGUID, onOff);
  }

  @override
  void undo() {
    notifier.restoreLayersWithoutHistory(_beforeLayers);
  }

  @override
  String getTitle() => 'Toggling layer multiSelect $onOff';
}

// CLEAR all LAYER multi selection
class ClearLayerMultiSelectionCommand implements AppCommand {
  final FileNotifier notifier;
  late final List<FileLayer> _beforeLayers;

  ClearLayerMultiSelectionCommand(this.notifier);

  @override
  void execute() {
    _beforeLayers = [...notifier.layers];
    notifier.clearLayerMultiSelection();
  }

  @override
  void undo() {
    notifier.restoreLayersWithoutHistory(_beforeLayers);
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

class AddKeyFramesCommand implements AppCommand {
  final FileNotifier notifier;
  final FileLayer layer;
  final List<int> keyFrames;
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
  final List<int> keyFrames;
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
