// contrils the specific file's model
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utility/drawy/drawy_path.dart';

class FileLayer {
  String LayerName;
  // active in mouse selection (ready for moving / deleting)
  bool active = false;
  // locked in mouse selection (disable editing of contents)
  bool locked = false;
  // visible in scene
  bool hidden = false;
  List<DrawyPath> drawPaths = [];
  FileLayer({this.LayerName = "Unnamed Layer", this.active = false});
}

class FileModel {
  const FileModel({
    this.fileName = "File1",
    this.fps = 30,
    this.timelineDuration = 5.0,
    this.layers = const [],
  });

  // Project file name
  final String fileName;
  // Project frame rate per seconds
  final int fps;
  // file duration (seconds)
  final List<FileLayer> layers;
  final double timelineDuration;

  FileModel copyWith({
    String? fileName,
    int? fps,
    double? timelineDuration,
    List<FileLayer>? layers,
  }) {
    return FileModel(
      fileName: fileName ?? this.fileName,
      fps: fps ?? this.fps,
      timelineDuration: timelineDuration ?? this.timelineDuration,
      layers: layers ?? this.layers,
    );
  }
}

class FileNotifier extends Notifier<FileModel> {
  @override
  FileModel build() {
    debugPrint("file model innitialized");
    // initial default data for app
    return FileModel(
      fileName: 'File1',
      layers: [FileLayer(LayerName: "Layer 0", active: true)],
    );
  }

  void setFileName(String name) => state = state.copyWith(fileName: name);
  void setFPS(int fps) => state = state.copyWith(fps: fps);

  void setTimelineDuration(double dur) =>
      state = state.copyWith(timelineDuration: dur);

  // add a new blank layer
  void addLayer() {
    var newLayer = FileLayer(LayerName: "Layer ${state.layers.length}");
    final updatedLayers = [...state.layers, newLayer];
    state = state.copyWith(layers: updatedLayers);
  }

  void removeLayer(FileLayer layer) {
    final updatedLayers = state.layers.where((l) => l != layer).toList();
    state = state.copyWith(layers: updatedLayers);
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
