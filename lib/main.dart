import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/main_stage.dart';
import 'package:shapey/theme.dart';
import 'package:shapey/utility/utility_theme.dart';

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

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Roboto", "Fredoka");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'Shapey',
      debugShowCheckedModeBanner: false,
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: const MainStage(),
    );
  }
}
