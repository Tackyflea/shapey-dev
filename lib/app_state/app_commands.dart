import 'package:shapey/app_state/app_history.dart';
import 'package:shapey/app_state/app_model.dart';
import 'package:shapey/app_state/file_model.dart';
import 'package:shapey/shape_canvas.dart';
import 'package:shapey/utility/drawy/drawy.dart';
import 'package:shapey/utility/drawy/e_interact_type.dart';
import 'package:vector_math/vector_math.dart';

//https://medium.com/@aprayush20/understanding-design-patterns-with-dart-01-chain-of-responsibility-command-pattern-b93da4ea9231
// Execute and undo pen draw
class DrawyPenCommand implements AppCommand {
  final ShapeCanvasState _shapeCanvas;
  final FileNotifier fileNotifier;
  final Vector2 newPosition;
  final int currentFrame;
  final FileLayer layer;
  late final FileLayer _beforeLayer;

  DrawyPenCommand(
    this._shapeCanvas,
    this.fileNotifier,
    this.newPosition,
    this.currentFrame,
    this.layer,
  ) {
    _beforeLayer = fileNotifier.getLayer(layer.guid()).deepCopy();
  }

  @override
  void execute() {
    final drawPaths = _shapeCanvas.penMode(newPosition);
    fileNotifier.updateLayerPathsWithClone(
      layer.guid(),
      currentFrame,
      drawPaths,
    );

    final updatedData = fileNotifier
        .getLayer(layer.guid())
        .frameData
        .keyFrames[currentFrame];
    _shapeCanvas.drawy.load(updatedData);
  }

  @override
  void undo() {
    fileNotifier.restoreLayer(layer.guid(), _beforeLayer);
    _shapeCanvas.drawy.load(_beforeLayer.frameData.keyFrames[currentFrame]);
  }

  @override
  String getTitle() => 'add pen point at $newPosition';
}

class DrawySelectCommand implements AppCommand {
  final ShapeCanvasState _shapeCanvas;
  final FileNotifier fileNotifier;
  final Vector2 newPosition;
  final int currentFrame;
  final FileLayer layer;
  late final FileLayer _beforeLayer;

  DrawySelectCommand(
    this._shapeCanvas,
    this.fileNotifier,
    this.newPosition,
    this.currentFrame,
    this.layer,
  ) {
    _beforeLayer = fileNotifier.getLayer(layer.guid()).deepCopy();
  }

  @override
  void execute() {
    _shapeCanvas.selectMode(newPosition);
    final drawPaths = _shapeCanvas.drawy.drawPaths;
    fileNotifier.updateLayerPathsWithClone(
      layer.guid(),
      currentFrame,
      drawPaths,
    );
    final updatedData = fileNotifier
        .getLayer(layer.guid())
        .frameData
        .keyFrames[currentFrame];
    _shapeCanvas.drawy.load(updatedData);
  }

  @override
  void undo() {
    fileNotifier.restoreLayer(layer.guid(), _beforeLayer);
    _shapeCanvas.drawy.load(_beforeLayer.frameData.keyFrames[currentFrame]);
  }

  @override
  String getTitle() => 'move point to $newPosition';
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
    _beforeActiveLayer = appNotifier.activeLayer;

    fileNotifier.clearLayerMultiSelection();
    fileNotifier.addLayer();

    final newLayerGUID = fileNotifier.layers.last.guid();
    fileNotifier.setMultiSelectActive(newLayerGUID, true);
    appNotifier.updateActiveLayer(newLayerGUID);
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
  late final String? _beforeActiveLayer;

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

    if (!shiftDown) {
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
  String getTitle() => 'toggle layer multiSelect $onOff';
}

// CLEAR all LAYER multi selection
class ClearLayerMultiSelectionCommand implements AppCommand {
  final FileNotifier fileNotifier;
  final AppNotifier appNotifier;
  late final List<FileLayer> _beforeLayers;
  late final String? _beforeActiveLayer;

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
  String getTitle() => 'clear all layer multi selection';
}

class RemoveLayerCommand implements AppCommand {
  final FileNotifier fileNotifier;
  final FileLayer layer;
  late final List<FileLayer> _beforeLayers;

  RemoveLayerCommand(this.fileNotifier, this.layer);

  @override
  void execute() {
    _beforeLayers = [...fileNotifier.layers];
    fileNotifier.removeLayer(layer); // normal remove (pushes history)
  }

  @override
  void undo() {
    fileNotifier.restoreLayersWithoutHistory(_beforeLayers);
  }

  @override
  String getTitle() => 'remove layer "${layer.name()}"';
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
  String getTitle() => 'set active frame to $frame';
}

class AddKeyFramesCommand implements AppCommand {
  final FileNotifier fileNotifier;
  final FileLayer layer;
  final Set<int> keyFrames;
  late final List<FileLayer> _beforeLayers;

  AddKeyFramesCommand(this.fileNotifier, this.layer, this.keyFrames);

  @override
  void execute() {
    _beforeLayers = [...fileNotifier.layers];
    fileNotifier.addKeyFrames(layer, keyFrames);
  }

  @override
  void undo() {
    fileNotifier.restoreLayersWithoutHistory(_beforeLayers);
  }

  @override
  String getTitle() => 'add keyframes to "${layer.name()}"';
}

class RemoveKeyFramesCommand implements AppCommand {
  final FileNotifier fileNotifier;
  final FileLayer layer;
  final Set<int> keyFrames;
  late final List<FileLayer> _beforeLayers;

  RemoveKeyFramesCommand(this.fileNotifier, this.layer, this.keyFrames);

  @override
  void execute() {
    _beforeLayers = [...fileNotifier.layers];
    fileNotifier.removeKeyFrames(layer, keyFrames);
  }

  @override
  void undo() {
    fileNotifier.restoreLayersWithoutHistory(_beforeLayers);
  }

  @override
  String getTitle() => 'remove keyframes from "${layer.name()}"';
}

class AddInitialLayerCommand implements AppCommand {
  final FileNotifier fileNotifier;
  final AppNotifier appNotifier;
  late final FileLayer _layer;

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
  }

  @override
  String getTitle() => "add initial layer";
}
