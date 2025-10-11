import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:shapey/theme.dart';
import 'package:shapey/utility/Utility.dart';
import 'sections/StageWidget.dart';
import 'sections/ToolsWidget.dart';
import 'sections/TopWidget.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    TextTheme textTheme = createTextTheme(context, "Roboto", "Fredoka");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      title: 'Shapey',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    FixedTrackSize tooltipWidth = 150.px;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceDim,
      body: Center(
        //https://pub.dev/documentation/flutter_layout_grid/latest/
        child: LayoutGrid(
          areas: '''
          header header header
          tools    content content
          ''',
          columnSizes: [tooltipWidth, 1.fr, 1.fr],
          rowSizes: [tooltipWidth, 1.fr],
          columnGap: 12,
          rowGap: 12,
          children: [
            TopWidget().inGridArea('header'),
            ToolsWidget().inGridArea('tools'),
            StageWidget().inGridArea('content'),
          ],
        ),
      ),
    );
  }
}
