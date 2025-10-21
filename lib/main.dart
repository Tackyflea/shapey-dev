import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/App.dart';

var initSize = Size(1240, 698);
var minSize = Size(640, 480);
void main() {
  runApp(ProviderScope(child: App()));
  doWhenWindowReady(() {
    final win = appWindow;
    win.minSize = minSize;
    win.size = initSize;
    win.alignment = Alignment.center;
    win.title = "Shapey";
    win.show();
  });
}
