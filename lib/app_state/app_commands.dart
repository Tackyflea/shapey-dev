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
  final String layerGUID;

  late final List<FileLayer> _beforeLayers;

  DrawyPenCommand(
    this._shapeCanvas,
    this.fileNotifier,
    this.newPosition,
    this.currentFrame,
    this.layerGUID,
  );

  @override
  void execute() {
    _beforeLayers = fileNotifier.layers
        .map((layer) => layer.deepCopy())
        .toList();

    print(
      "EXECUTE: Before penMode, drawy has ${_shapeCanvas.drawy.drawPaths.length} paths",
    );
    final drawPaths = _shapeCanvas.penMode(newPosition);
    print(
      "EXECUTE: After penMode, got ${drawPaths.length} paths with ${drawPaths.firstOrNull?.pathPoints.length ?? 0} points",
    );

    fileNotifier.setLayerPaths(layerGUID, currentFrame, drawPaths);
    print("EXECUTE: Saved to file");
  }

  @override
  void undo() {
    print(
      "UNDO: Before restore - drawPaths count: ${_shapeCanvas.drawy.drawPaths.length}",
    );

    // Undo file state
    fileNotifier.restoreLayersWithoutHistory(_beforeLayers);

    print(
      "UNDO: After restore - drawPaths count: ${_shapeCanvas.drawy.drawPaths.length}",
    );
    print("UNDO: Does this trigger a reload?");
  }

  @override
  String getTitle() => 'add pen point at $newPosition';
}

class DrawySelectCommand implements AppCommand {
  final ShapeCanvasState _shapeCanvas;
  final Vector2 newPosition;

  DrawySelectCommand(this._shapeCanvas, this.newPosition);

  @override
  void execute() {
    _shapeCanvas.selectMode(newPosition);
  }

  @override
  void undo() {
    // TODO: IMPLEMENT
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
