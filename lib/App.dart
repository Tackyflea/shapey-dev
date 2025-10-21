import 'package:flutter/material.dart';
import 'package:shapey/MainStage.dart';
import 'package:shapey/theme.dart';
import 'package:shapey/utility/Utility.dart';

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
