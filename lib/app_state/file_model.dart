// contrils the specific file's model
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/app_model.dart';
import 'package:uuid/uuid.dart';

import '../utility/drawy/drawy_path.dart';

//TODO ,send this to a physical file
const int DEFAULT_FPS = 30;
const double DEFAULT_TIMELINE_DURATION = 5.0;

// individual keyframe data
class Data {
  final List<DrawyPath> drawPaths;

  Data({required this.drawPaths});
  Data copyWith({List<DrawyPath>? drawPaths}) {
    return Data(drawPaths: drawPaths ?? List<DrawyPath>.from(this.drawPaths));
  }
}

// Data for the frames, if any
class FrameData {
  final List<int> activeFrames;
  final int frameCount;
  final Map<int, Data> keyFrames;

  FrameData({
    List<int>? activeFrames,
    int? frameCount,
    Map<int, Data>? keyFrames,
  }) : activeFrames = activeFrames ?? [],
       frameCount = frameCount ?? 0,
       keyFrames = keyFrames ?? {};

  FrameData copyWith({
    List<int>? activeFrames,
    int? frameCount,
    Map<int, Data>? keyFrames,
  }) {
    return FrameData(
      activeFrames: activeFrames ?? List<int>.from(this.activeFrames),
      frameCount: frameCount ?? this.frameCount,
      keyFrames: keyFrames ?? Map<int, Data>.from(this.keyFrames),
    );
  }
}

// Details on the individual layer
class LayerData {
  final String GUID;
  final String LayerName;
  final bool MultiSelectActive;
  final bool locked;
  final bool hidden;

  LayerData({
    String? guid,
    String? layerName,
    bool? multiSelectActive,
    bool? locked,
    bool? hidden,
  }) : GUID = guid ?? Uuid().v4(),
       LayerName = layerName ?? "Untitled",
       MultiSelectActive = multiSelectActive ?? false,
       locked = locked ?? false,
       hidden = hidden ?? false;

  LayerData copyWith({
    String? guid,
    String? layerName,
    bool? multiSelectActive,
    bool? locked,
    bool? hidden,
  }) {
    return LayerData(
      guid: guid ?? GUID,
      layerName: layerName ?? LayerName,
      multiSelectActive: multiSelectActive ?? MultiSelectActive,
      locked: locked ?? this.locked,
      hidden: hidden ?? this.hidden,
    );
  }
}

class FileLayer {
  LayerData layerData;
  FrameData frameData;

  FileLayer({LayerData? layerData, FrameData? frameData})
    : layerData = layerData ?? LayerData(),
      frameData = frameData ?? FrameData();

  // Keep mutable setters for convenience during construction
  void setName(String newName) {
    layerData = layerData.copyWith(layerName: newName);
  }

  void setMultiSelect(bool onOff) {
    layerData = layerData.copyWith(multiSelectActive: onOff);
  }

  void setFrameCount(int newCount) {
    frameData = frameData.copyWith(frameCount: newCount);
  }

  void addKeyFrame(int frameIndex) {
    final newKeyFrames = Map<int, Data>.from(frameData.keyFrames);
    newKeyFrames[frameIndex] = Data(drawPaths: []);
    frameData = frameData.copyWith(keyFrames: newKeyFrames);
  }

  void removeKeyFrame(int frameIndex) {
    final newKeyFrames = Map<int, Data>.from(frameData.keyFrames);
    newKeyFrames.remove(frameIndex);
    frameData = frameData.copyWith(keyFrames: newKeyFrames);
  }

  String name() => layerData.LayerName;
  String guid() => layerData.GUID;
  bool isMultiSelectActive() => layerData.MultiSelectActive;
  bool isLocked() => layerData.locked;
  bool isHidden() => layerData.hidden;
  int frameCount() => frameData.frameCount;

  FileLayer copyWith({LayerData? layerData, FrameData? frameData}) {
    return FileLayer(
      layerData: layerData ?? this.layerData,
      frameData: frameData ?? this.frameData,
    );
  }
}

class FileModel {
  const FileModel({
    this.fileName = "File1",
    this.fps = DEFAULT_FPS,
    this.timelineDuration = DEFAULT_TIMELINE_DURATION,
    this.layers = const [],
    this.layersHistory = const [],
  });
  // Project file name
  final String fileName;
  // Project frame rate per seconds
  final int fps;
  // file duration (seconds)
  final List<FileLayer> layers;
  final List<List<FileLayer>> layersHistory;
  final double timelineDuration;

  FileModel copyWith({
    String? fileName,
    int? fps,
    double? timelineDuration,
    List<FileLayer>? layers,
    List<List<FileLayer>>? layersHistory,
  }) {
    return FileModel(
      fileName: fileName ?? this.fileName,
      fps: fps ?? this.fps,
      timelineDuration: timelineDuration ?? this.timelineDuration,
      layers: layers ?? this.layers,
      layersHistory: layersHistory ?? this.layersHistory,
    );
  }
}

class FileNotifier extends Notifier<FileModel> {
  @override
  FileModel build() {
    debugPrint("file model innitialized");
    var newFile = FileModel();

    return newFile;
  }

  void setFileName(String name) => state = state.copyWith(fileName: name);
  void setFPS(int fps) => state = state.copyWith(fps: fps);

  void setTimelineDuration(double dur) =>
      state = state.copyWith(timelineDuration: dur);

  // toggles that this layer is multi selectable
  void setMultiSelectActive(String layerGUID, bool onOff) {
    final updatedLayers = state.layers.map((layer) {
      if (layer.guid() == layerGUID) {
        // create a new Layer object with updated data
        return layer.copyWith(
          layerData: layer.layerData.copyWith(multiSelectActive: onOff),
        );
      }
      return layer; // keep as-is
    }).toList();

    state = state.copyWith(
      layers: updatedLayers,
      layersHistory: [...state.layersHistory, state.layers],
    );
  }

  void clearLayerMultiSelection() {
    final updatedLayers = state.layers.map((layer) {
      return layer.copyWith(
        layerData: layer.layerData.copyWith(multiSelectActive: false),
      );
    }).toList();

    state = state.copyWith(
      layers: updatedLayers,
      layersHistory: [...state.layersHistory, state.layers],
    );
  }

  void addKeyFrames(FileLayer layer, Set<int> frameIndices) {
    final current = state;

    final updatedLayers = current.layers.map((l) {
      if (l == layer) {
        final newKeyFrames = Map<int, Data>.from(l.frameData.keyFrames ?? {});
        for (final index in frameIndices) {
          newKeyFrames[index] = Data(drawPaths: []);
        }

        final updatedFrameData = l.frameData.copyWith(keyFrames: newKeyFrames);
        return l.copyWith(frameData: updatedFrameData);
      }
      return l;
    }).toList();

    final updatedHistory = [...current.layersHistory, current.layers];

    state = current.copyWith(
      layers: updatedLayers,
      layersHistory: updatedHistory,
    );
  }

  void removeKeyFrames(FileLayer layer, Set<int> frameIndices) {
    final current = state;

    final updatedLayers = current.layers.map((l) {
      if (l == layer) {
        final newKeyFrames = Map<int, Data>.from(l.frameData.keyFrames ?? {});
        for (final index in frameIndices) {
          newKeyFrames.remove(index);
        }

        final updatedFrameData = l.frameData.copyWith(keyFrames: newKeyFrames);
        return l.copyWith(frameData: updatedFrameData);
      }
      return l;
    }).toList();

    final updatedHistory = [...current.layersHistory, current.layers];

    state = current.copyWith(
      layers: updatedLayers,
      layersHistory: updatedHistory,
    );
  }

  // add a new blank layer
  FileLayer addLayer() {
    print("add layer");
    final current = state;
    final newLayer = FileLayer();
    newLayer.setName("Layer ${current.layers.length}");
    newLayer.setFrameCount((DEFAULT_FPS * DEFAULT_TIMELINE_DURATION).toInt());

    final updatedLayers = [...current.layers, newLayer];
    final updatedHistory = [...current.layersHistory, current.layers];

    state = current.copyWith(
      layers: updatedLayers,
      layersHistory: updatedHistory,
    );
    return newLayer;
  }

  int removeLayer(FileLayer layer) {
    final current = state;
    final index = current.layers.indexOf(layer);
    final updatedLayers = current.layers.where((l) => l != layer).toList();
    final updatedHistory = [...current.layersHistory, current.layers];

    state = current.copyWith(
      layers: updatedLayers,
      layersHistory: updatedHistory,
    );
    return index;
  }

  // insert at index (records history)
  void insertLayer(int index, FileLayer layer) {
    final current = state;
    final updatedLayers = [...current.layers]..insert(index, layer);
    final updatedHistory = [...current.layersHistory, current.layers];

    state = current.copyWith(
      layers: updatedLayers,
      layersHistory: updatedHistory,
    );
  }

  void restoreLayersWithoutHistory(List<FileLayer> layers) {
    state = state.copyWith(layers: layers);
  }

  void updateLayer(String layerGUID, FileLayer Function(FileLayer) updateFn) {
    final current = state;
    final updatedLayers = current.layers.map((layer) {
      if (layer.guid() == layerGUID) {
        return updateFn(layer); // Apply the update function
      }
      return layer;
    }).toList();

    final updatedHistory = [...current.layersHistory, current.layers];

    state = current.copyWith(
      layers: updatedLayers,
      layersHistory: updatedHistory,
    );
  }

  void setLayerPaths(String layerGUID, int frame, List<DrawyPath>? newPaths) {
    print("setLayerPaths: Saving ${newPaths?.length} paths");
    updateLayer(layerGUID, (layer) {
      final newKeyFrames = {...layer.frameData.keyFrames};
      newKeyFrames[frame] = Data(
        drawPaths: newPaths?.map((path) => path.copy()).toList() ?? [],
      );
      return layer.copyWith(
        paths: layer.layerData.copyWith(multiSelectActive: onOff),
      );
    });
  }

  String get name => state.fileName;
  int get fps => state.fps;
  double get timelineDuration => state.timelineDuration;
  List<FileLayer> get layers => state.layers;
}

// the provider
final fileNotifier = NotifierProvider<FileNotifier, FileModel>(
  FileNotifier.new,
);
