import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shapey/utility/stage_intents.dart';
import 'sections/stage_widget.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

class MainStage extends StatefulWidget {
  const MainStage({super.key});

  @override
  State<MainStage> createState() => _MainStageState();
}

final double borderSize = 1;

class _MainStageState extends State<MainStage> {
  @override
  Widget build(BuildContext context) {
    // Utility grab window size
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surfaceDim,
      body: WindowBorder(
        color: colorScheme.surfaceContainerLow,
        width: borderSize,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Expanded(child: StageWidget())],
        ),
      ),
    );
  }
}
