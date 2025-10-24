// contrils the specific file's model
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FileModel {
  const FileModel({
    this.fileName = "File1",
    this.fps = 30,
    this.timelineDuration = 5.0,
  });

  // Project file name
  final String fileName;
  // Project frame rate per seconds
  final double fps;
  // file duration (seconds)
  final double timelineDuration;
  FileModel copyWith({
    String? fileName,
    double? fps,
    double? timelineDuration,
  }) {
    return FileModel(
      fileName: fileName ?? this.fileName,
      fps: fps ?? this.fps,
      timelineDuration: timelineDuration ?? this.timelineDuration,
    );
  }
}

class FileNotifier extends Notifier<FileModel> {
  @override
  FileModel build() {
    debugPrint("file model innitialized");
    // initial default data for app
    return FileModel(fileName: 'File1');
  }

  void setFileName(String name) => state = state.copyWith(fileName: name);
  void setFPS(double fps) => state = state.copyWith(fps: fps);
  void setTimelineDuration(double dur) =>
      state = state.copyWith(timelineDuration: dur);

  String get name => state.fileName;
  double get fps => state.fps;
  double get timelineDuration => state.timelineDuration;
}

// the provider
final fileNotifier = NotifierProvider<FileNotifier, FileModel>(
  FileNotifier.new,
);
