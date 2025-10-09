import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import 'CanvasWidget.dart';
import 'ToolsWidget.dart';
import 'TopWIdget.dart';
import 'Utility.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
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
            CanvasWidget().inGridArea('content'),
          ],
        ),
      ),
    );
  }
}
